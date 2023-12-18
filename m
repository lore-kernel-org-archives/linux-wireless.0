Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8963C5D74C
	for <linux-wireless@vger.kernel.org>; Mon, 18 Dec 2023 18:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeV1T1/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EEAC433C7;
	Mon, 18 Dec 2023 18:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702925107;
	bh=2+MiFpT+5Mh01hC/51kXrth8gzjCKgQZNx/OzBMY2tk=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=PeV1T1/HsBPgm9aIfbz2qFe16bcnyDb3gMYrG41/XRiHiU2pLurHPcaeG6LddR8fj
	 Z5m9GTmOlHx9kiP5ojKkBdOJWJwxxMpaxvV31mADgI7isZoW4sGdnMB7F+s4xsvHb3
	 Bh1/MfySYIU+iEqG7lVOhbRXGZoiP3uGLgxF+p1staYE1adrlG5g1EIH89d3tiXuqx
	 yvOG91fCww48qEitfCRiH699t7WD+j/PrB3+Ps/r5V/zIH3mwcCKa1l5Te9URX0zJv
	 eSxfa3mB2CjBD6YFtdVQgW0Ysqm4roCXXMD94rDEYqddD9bVXKNsLgIBWukSm66g/e
	 NppQWw7tZL4EQ==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 02/11] wifi: ath9k: delete some unused/duplicate macros
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230629231625.951744-3-wlooi@ucalgary.ca>
References: <20230629231625.951744-3-wlooi@ucalgary.ca>
To: Wenli Looi <wlooi@ucalgary.ca>
Cc: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
 linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <170292510448.424292.12185805862441723582.kvalo@kernel.org>
Date: Mon, 18 Dec 2023 18:45:06 +0000 (UTC)

Wenli Looi <wlooi@ucalgary.ca> wrote:

> The rate macros are for AR9002 and not correct for AR9003.
> 
> The AGC 3 macros are unused and have incorrect values, at least for
> QCN5502, where AR_AGC3_BASE should be 0x2de00.
> 
> This change does not appear to affect the final binary.
> 
> Signed-off-by: Wenli Looi <wlooi@ucalgary.ca>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

504130491026 wifi: ath9k: delete some unused/duplicate macros

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230629231625.951744-3-wlooi@ucalgary.ca/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

