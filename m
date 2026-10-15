Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E083D88E0;
	Thu, 15 Oct 2026 23:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792108250; cv=none; b=CZddyMpczEAXWOgLYvDQyujsWUoZ6+8aCpUoqMl/mT+FmcT7M50gaNr6uX1ZRSPCLBUeXdZlgMt41cYVianslVenT8ThJZ6BAMEvTH1ATvRWFq7jagZk8XetJNPYzaHvvHJEgYaQfTN7KohyKCUeiWC5OPgFboD9JNrCNlHc3Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792108250; c=relaxed/simple;
	bh=ikJoJPwbSdb/Kx2tA9JQdCtmhf1JFwpEBFN8ylwFqlc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=aHB5TdwgaLncRkd7PaDoqrou2Lovp6ll2UrXJvcOvV/rhSTkP4hKeZQfieguBaNg/wlA0i/jiVkX2MldkjP9A/jC6gRGu84NiiXLPt9Y9EYzz4cHF+71QSWkHkYP7cgnFGlkC/Ea60ToP4PZQX61g5xdDGkfyI9Dmwua6EyW9Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CR6ndoP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CR6ndoP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D351F000C4;
	Thu, 15 Oct 2026 23:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792108248;
	bh=klFZ7fVarUCOd0SSsc0JTlupqQqXYmWL76hvCW6GGTQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=CR6ndoP1GsLKQZYhBfM889rwJZB6b69QpzsanJbP/kd1pmqbxDx4biK94+xqcPArU
	 5Ti6bdIT50clvPrTtHi0uChSksZ6oq4kgwYzoPO6qxUoohEm009mUW7ePZiXiC82X0
	 AWrdJH7JMj/tZ1RQmKza6kRQWb7OReVPo8Bkknx8n9/a1O6TMsD/pP2Bn/mxJHGaA+
	 SgVYrK/GHFSUSSnE2QPX+Vt+rWUCpQekM3yHtABaPtcG9nh97txU+/rTUB1Rdstyuk
	 yeMqsMvI+qevaa6wvn+uVthmd+i45NfNxDcxQgj7Ee420GJHfz+DIWE2A9qic3qjeZ
	 7R0z5OO+hL/dg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A3CF3808209;
	Thu, 15 Oct 2026 23:50:48 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-next-2026-10-15
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179210824677.4159579.9272835662740074363.git-patchwork-notify@kernel.org>
Date: Thu, 15 Oct 2026 23:50:46 +0000
References: <20261015105035.137870-3-johannes@sipsolutions.net>
In-Reply-To: <20261015105035.137870-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Oct 2026 12:47:49 +0200 you wrote:
> Hi,
> 
> Quite a lot of content, some drivers came quite late
> with a lot of content, I've asked them to send stuff
> earlier... But there's the promised RTNL reduction
> here now, after some shaking down.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-next-2026-10-15
    https://git.kernel.org/netdev/net-next/c/9b0be45d4d52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


