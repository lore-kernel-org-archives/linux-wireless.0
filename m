Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6C743E487;
	Wed,  6 May 2026 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778078473; cv=none; b=G/AkO7Brtd0ei1BiS1esKSDvziYg3f3UxM2CZaDEWe1JKdiNMciFqVdDSinpeJoaeYwA3ZwcQi/8l2V/kMQAlHwMeD3iRIBUXmC03VUfpAFqKd1CSuVnbWwSvTq8+X9eW1ia52r8cm01VSU06aCyh/uzB6eY8Ew+s2U5to7QLKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778078473; c=relaxed/simple;
	bh=ru8DNl3EW+CRTL07xbjxItGY/AcEnBER1Jfmf1pgKdY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=gxmXjNjJ8bU1zYAmAnhw2KPV4602rPqCNY6ZRKVgglazu/ObaLFGFVcRRteBS5nlJlvzfHlcRQZbuLIxROB9Ea4KsyYZdG4EC4GtWilbU7+UEKTe1ZCVlNaJAHPDPCMUooLIvC81SVFwx55MGoKXrjCx9lCB8lA6/7uhBfim/yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lCGkvFzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lCGkvFzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB373C2BCB0;
	Wed,  6 May 2026 14:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778078472;
	bh=ru8DNl3EW+CRTL07xbjxItGY/AcEnBER1Jfmf1pgKdY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=lCGkvFztZrAIqXxMPNVKpEr0U/wMg48FhX/h1SeAsAKlaUJVBxogIoPWixZSI5MQo
	 kJSLWdX5gkM//pG89f3wjd8CNxk/lkh7r89hWXADYRYLamrJzhUG9DzXhZaFyUnU7A
	 FhYy28oNge5/Hfhrj5G7xxeHetLgaJ+8fKxsKy8AxjbfDctDbQCpDDxObawpu2TvJV
	 v11rFkV339g6vfmb+jPQrCjQaU3w/rSRoWDafio18YzKzPY2NmY3FNqGEgZbDZLJc1
	 ySJBETHPFUIZVrxA9xjKd7ollzf11yD8m2I4ZDX2sPxrIxLpd9Kx1Zlt8th3cwuT98
	 AIDkI5m6JQ2yA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9EB43930888;
	Wed,  6 May 2026 14:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-2026-05-06
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177807842255.3025991.3546666403202987231.git-patchwork-notify@kernel.org>
Date: Wed, 06 May 2026 14:40:22 +0000
References: <20260506110325.219675-3-johannes@sipsolutions.net>
In-Reply-To: <20260506110325.219675-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  6 May 2026 13:01:56 +0200 you wrote:
> Hi,
> 
> More content given last week's kunit failure, but I've fixed
> that now, sorry about that. Things are all over really.
> 
> Please pull and let us know if there's any problem.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-2026-05-06
    https://git.kernel.org/netdev/net/c/b89e0100a5f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


