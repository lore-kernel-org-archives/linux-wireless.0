Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9781DFD86;
	Tue, 28 Jan 2025 22:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738103055; cv=none; b=EMJoBP+9Cdlt1rcN5ZcNeQj1PegVdVAwn4h8Av/NBdVmFnwhhjrmQE7OhNVU0qyXmBZ4/+Z/YWKpnIgvmRU926wVkslsYzdxI6USDv/4Oy0MH0uUy2oDOl0Zz/k+OAoCmTnDDXFhRR5JwOjYr3fH+8UrexdtOw/tXrzphytJaG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738103055; c=relaxed/simple;
	bh=WEytLMAl7cwCDJw/5DRZVkqcz9UySDzwuhOZNmFaZTs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LL0oKgIy+q91A+NSOPvsyI0NLyt1DBkw0OiR9lk4WZmwlybAZ7J6bZi3/85EWXUHWHhZFI8fD8cKXxnt6fYQXH5JXmMcoam4pif/pXoycc2e1S4wufv3+kQY2REP9uWGa2N4ZBxnOOEWvBpGhkToJVuGghSdePS8w8hK7AwvKWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=upPXOBtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="upPXOBtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC1EC4CED3;
	Tue, 28 Jan 2025 22:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738103054;
	bh=WEytLMAl7cwCDJw/5DRZVkqcz9UySDzwuhOZNmFaZTs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=upPXOBtFrPxgXwmb7BJKBgHroVTxe4QEsdbSuLn7DexDjFoeMtlnPE79wU4LFs3Uc
	 7BcQbtvsc/ZDUiwi/yv4h19+0XeYKCdCCvj1M55FMF1+OXse+WA5Llbn7RfcE2ecOm
	 omrMJeFFTupyJRMfm0+9DzmDatGzptrKL8bQuBvAy9mQaeldC+va9foKb06x+OOY0+
	 BuuYf4v+HaTf2NNUj31WN7DXonSqQiNbM3evFN0BHfHETZhD2AlpCOKzeFCPVRDjp9
	 g5MDn2D6aLJQE0PAN3Oo9qZEYwstcs2ZekRLsWbo7CbVTwcjSzmjl54BYPE/rnJLpj
	 BfXuNublVg8kg==
Date: Tue, 28 Jan 2025 14:24:13 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ath12k@lists.infradead.org, ath11k@lists.infradead.org,
 ath10k@lists.infradead.org, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Stepping down as maintainer
Message-ID: <20250128142413.3a86418e@kernel.org>
In-Reply-To: <87wmefguqt.fsf@kernel.org>
References: <87wmefguqt.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Jan 2025 11:20:26 +0200 Kalle Valo wrote:
> Hi everyone,
> 
> I'm stepping down from all my maintainer roles. My first commit
> feed9bab7b14 ("spi: omap2_mcspi PIO RX fix") to the kernel was back in
> 2008 for v2.6.24 so I have been here for a long time. Thank you everyone
> who I have worked with, there are too many to list here.

Thank you for all the hard work over the years, Kalle!

You will certainly be missed
