Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC4751DDE9;
	Wed, 30 Sep 2026 21:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790803817; cv=none; b=iHHUP7qFnIYqDiGSdQL+zRbdcvfmmFXrQz+o8ffS5MXx0nJyME0cuofrbc/W02XJSYpe3EBnhZfDRXktZ9GT0Z2PBfTbtWqwxzbE/W7HiVFpvSOx7J8v4Uh8goKDHqfQSwa/fWw63iBItkwysij9rDqI0OO+29pG76Tkyt8jQK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790803817; c=relaxed/simple;
	bh=HVL5nzFx8DMRQPYBzs9F6KAedam2xZ5yO08knhnH81k=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=WXzNvvaCs6JT09TGS34iHRsesunz+uLc0hCBbCVfOUqUeZa4ZMjakkzxLIiiXfzH0pievvBQd9waY7gkO/9Pan4aeSj5+lKN2chWIvE9T+0J0x2yYD+A+uPPAnmx5CF+i3oYqvS6FP+q/X0oAJpcz2OvFPKWEdvvIdpknrvR1xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUDrc/4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUDrc/4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057F61F000FF;
	Wed, 30 Sep 2026 21:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790803816;
	bh=sSo30n9mnbT1mpfpYaX+fx7od1jbDf9S3MCbyDftOYA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=KUDrc/4KX1AEc1x660y5SpB5bc66L5ymxtQ3JOdfBctQtin2qfTCj/xI5cQVmW7va
	 HJyfw5RJltKv+wFdcUKqibMqvDy7dI8z3rAtoCL7YWwOSRLRmyp6PVQnHz9kiRaAgD
	 J3zXmSJVHU1fEEPjMAq4CaeRLm8Q87z9XG8jPTnhNEowTWn0FrFzs/VzJfo+U0501p
	 fYD1antijsvrBXTaZesAewfrXSVHTePCFsj2Qq0j9HnjFJrILpERIwnClU2GwgJW1u
	 zREHbZ3yQfze57QgenT2KSK0NT+qVqIqHB51iR+R3TLwSIOfGcFnlvdoO9XU08TvgW
	 Af4ZyIPIeriNQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F15083A56773;
	Wed, 30 Sep 2026 21:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-next-2026-09-30
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179080381478.2136741.17430850601503649199.git-patchwork-notify@kernel.org>
Date: Wed, 30 Sep 2026 21:30:14 +0000
References: <20260930124547.228697-29-johannes@sipsolutions.net>
In-Reply-To: <20260930124547.228697-29-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 30 Sep 2026 14:45:08 +0200 you wrote:
> Hi,
> 
> Also for -next we have quite a bit of new things, but apart from
> CIP (control frame integrity protection) support it's mostly driver
> changes.
> 
> Please pull and let us know if there's any problem.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-next-2026-09-30
    https://git.kernel.org/netdev/net-next/c/1631d79ae57d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


