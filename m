Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39273D0AC;
	Thu,  7 Dec 2023 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rXausfPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3E4C433C8;
	Thu,  7 Dec 2023 14:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701958017;
	bh=xTh+lYWi7+gEvbYpEe+2SLArpLruhAgZVoqIIqhHYkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rXausfPyYF5Knz6tChkiLC3ES4oc2iPudrxyUVvZtZtYPOccQF6kWPTOUfUBP0hT1
	 G+AZtlPaHa5Q4ZeYP2/BVam8FwMJxpN3bN4FMT9/48hjwQZVKlJLpmhYV7zOooMvFL
	 Cu7SWr26r8nnToEyEc/HTTcl3j8+q38XSiQ+5j/K7lnSAnkaRd8l5SBhJJgHR8iDym
	 Y0NyDL5iCEIqI9hZwRq0RCZ/hZG/hvRvVcCr+EoBkcZyVC0aH1fo6K30rOGdkDGnmr
	 2E7P7Y1sGPR+fttDca0lacBoexFcVYtxP+WgKI2rGRWeb+bRA7PKTrIxtNEjKskDHP
	 sSaAogN+3W1fw==
Date: Thu, 7 Dec 2023 08:06:55 -0600
From: Seth Forshee <sforshee@kernel.org>
To: Chen-Yu Tsai <wens@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Add my certificate
Message-ID: <ZXHRf5uEMO1kMIKY@do-x1extreme>
References: <ZXHGsqs34qZyzZng@wens.tw>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXHGsqs34qZyzZng@wens.tw>

On Thu, Dec 07, 2023 at 09:20:50PM +0800, Chen-Yu Tsai wrote:
> As announced [1][2], I have taken over maintainership of the
> wireless-regdb project.
> 
> Add my certificate so that newer releases are valid to the kernel.
> Seth's certificate should be kept around for awhile, at least until
> a few new releases by me happen.
> 
> This should also be applied to stable trees so that stable kernels
> can utilize newly released database binaries.
> 
> [1] https://lore.kernel.org/linux-wireless/CAGb2v657baNMPKU3QADijx7hZa=GUcSv2LEDdn6N=QQaFX8r-g@mail.gmail.com/
> [2] https://lore.kernel.org/linux-wireless/ZWmRR5ul7EDfxCan@wens.tw/
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Chen-Yu Tsai <wens@kernel.org>

Acked-by: Seth Forshee <sforshee@kernel.org>
