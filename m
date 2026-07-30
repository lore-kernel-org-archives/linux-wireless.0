Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DE670830;
	Thu, 30 Jul 2026 00:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785370252; cv=none; b=hhN87mO8jJ9mJWY1CYEdBVPSBltjc735GhAnS9oSgQtB+UTfV107ioEGvkpoBbQvNjLBoTMsj3p7rAcgf+RuIKWfavpCDDYGql2jKrfrIY72NZQG0rYg8/5KN30KDdvzIZfNA5Vc6xS6PuwQE3v6uW9nZ/kZUxwbCuBZVhE1lMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785370252; c=relaxed/simple;
	bh=hZbnNZYTlIuzOJPK5+Dydjul8ZNKeHDVY4NvJ6omxPQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=qrIo1ftcjTw5PU8+DeSBNdFeQkdurQtV+YX8V3tX0rTt8o3bTKg8gq1YP6jo5PiUTef59Ok2zJ/xJJazNnZWP38HKm4yGfUmOsr1OIXvFLp/T9E2mqtto8z9Wpuygf+Igo0N3Rf46jjKUN+0XhncljdwyuCPgWjAZE8DEQUXGkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQhwVN8X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQhwVN8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCBC1F000E9;
	Thu, 30 Jul 2026 00:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785370249;
	bh=3fEmEoYtD335VF1av2SV00+cug+S+HXXY4n9sAP+VA8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ZQhwVN8XkbK6Es9t2jSJw1sHrhGosM6R1JPZSbAgvYRAR+ztrK80CyzG4navRBVq4
	 FLnKrKR1lWhmH9CipuCC6r7tHTl/YubngI2fu55svzkAUFZFctbjYYXrmxFAB249og
	 JRVZ5fUHBdFf10hICHqAFl6atgHNa+NI5agJKi561/BmJyrTo9wVHuBSqDni+oIYUG
	 lmBSSUGJxhfubzMwvfn9Mjvc2SMl8zfVIYmqdeqn5TM31q8uq5k9KG8QAXPWelzi2/
	 RgJy3SXxxsWBOxGziwPMeD2wgjQ72+q0CKS0TF7s6uEnYVod7KuomITJ8EyVabVSZM
	 V5bAOcDLegt4w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 197AF3926250;
	Thu, 30 Jul 2026 00:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-2026-07-29
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178537021389.3290991.12279912690137712219.git-patchwork-notify@kernel.org>
Date: Thu, 30 Jul 2026 00:10:13 +0000
References: <20260729071954.45655-3-johannes@sipsolutions.net>
In-Reply-To: <20260729071954.45655-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Jul 2026 09:18:13 +0200 you wrote:
> Hi,
> 
> So this week is _far_ less, thankfully. A couple more
> fixes that seemed important enough, but I've also been
> much more selective, in particular the 'mwifiex' driver
> seems to be a train-wreck, and has a lot of fixes and
> associated discussions still open - but I think I'll be
> leaving those for -next.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-2026-07-29
    https://git.kernel.org/netdev/net/c/82f0e98ba302

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


