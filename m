Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562E4343890;
	Thu,  4 Jun 2026 02:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780539622; cv=none; b=Wh4k0Jo1sYpxuMou5+awQy+mnC1weRBfw4oKSTE/aldYtVPnPYrgW1Pog/8D3sB7IwA3Rh9RXAqoVlQoRMXpaINWTlnqPvNasC7TqFKofgAEBJBAtDHVzeldO2pkT4L6qPR3lhPc9NPWX4NNugOqjTxj4Pyj4djuC3oYtYiPZxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780539622; c=relaxed/simple;
	bh=nt/HwTmCow5dv42xI1a8K/9JYxpd7JpspAR656fkpH4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=a5o5if479E56zSSmzbb/SHr2BYUhDJyTjXfLp8LJLtFappY+VRWuq5ARZRd79fB3tWCpuKlpZODw/0WSzBoVcUjklBNlTMooLbA3cldfHaS3cT7KFnsnF/KjZ1MTVKBaamFPWgqIOYW+DaIYPjYPn5jd1NhSoc1HAvpIv0D/J+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUA9/UHC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUA9/UHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4481F00893;
	Thu,  4 Jun 2026 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780539618;
	bh=+hmXS4U34AH1Xpy67XuolNkGjHnQ6n/VI1Ap1gmPo7Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=mUA9/UHCljUdNiLjLXa76IH79eZrU1iCCE+mzL/pQElQNZCPIRwGxrHfuNNkgcaXj
	 Iwgf9/h9SGC8hO+g3MWxbyzpyRm7EwH2iWsoEAGLzKIv+89yUoxc+Iw3fEkTbvw5Dp
	 abE6HWo/ZKixWBAEOXOdwyHR2zuPwhQ22P++29MOQrQcjdXnfS09cJdrq7C/ptsMMt
	 KCjHWPGtW10/j3/o67huJBOPGW6w6PV34R8eVoafQBPavyWk/YGuJLDvZfx4x0R0/W
	 9RyZbGIgcWNJ4cUAHGy6oeMkUesXf0l4F6TwcGWZXKF16UW56CRp6EYLzwMreDJeds
	 5WD04Q8OiPm8A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199E439308E1;
	Thu,  4 Jun 2026 02:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-2026-06-03
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178053961964.2207566.7336189080547624467.git-patchwork-notify@kernel.org>
Date: Thu, 04 Jun 2026 02:20:19 +0000
References: <20260603113208.171874-3-johannes@sipsolutions.net>
In-Reply-To: <20260603113208.171874-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  3 Jun 2026 13:31:24 +0200 you wrote:
> Hi,
> 
> And yet more things ... I'm going to defer a number of driver
> things to wireless-next though, e.g. a PCIe device IRQ race.
> 
> Please pull and let us know if there's any problem.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-2026-06-03
    https://git.kernel.org/netdev/net/c/ac056099822e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


