Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627BF4DBD6B;
	Wed, 16 Sep 2026 23:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789599682; cv=none; b=e8WNGWTAfZoFhZUH0Ov7ThuKT4BA1/4Nx2JcQ1qa2lL6VopRfQLkvTPpxEGJJDi61oe0vIt5M+yFPMG8y35WxPaQo+Bp6hhauMtItzPecD00fll2nH8lXnvzN4Op4aCZHY7DSOyRY+K07TIcPQfmHY9KUcj+9+VklwXwE1kLA64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789599682; c=relaxed/simple;
	bh=93RJ0b9Nbcj0EoOUg+YHsC6rl8O7AOlwHicENLbhICM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=HdVO3oztDW53vhtlK6yOtxIqQy4mHHzxXCk1Fki0enVKdO+pcc7fQB3/nSOYh/1YiARLzvDzVyoKxCaR1nRmUdkPsjbuPJ6Smg99r4viaJxdLdwOWoJvYVulkb5ViGgS0F88RaRGNfsLEUBrV6PWOfTXY7wwRJGhmPnVi9UU2Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bk4LW8Cu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bk4LW8Cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1821F000FF;
	Wed, 16 Sep 2026 23:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789599677;
	bh=T/LKB4vwvCEFL6rIXKqGzozNS2ZR6ZhKudjebWeJJ7Y=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=bk4LW8Cuq3lqd6jYx9SYqfkEpp6Wm8Kdlhi4GvQHfk2IB4GM6NJC2jiD13dOsxSFo
	 d8sZk+LxPry/jhBAFsO/AmpHNsPjOSD2+YBqfIL63uhfAl4DYJyBW7jTeD7f18Jsgs
	 lwLlGyEJvT5EedlOkWeC7aOSljT/0GBf9RF9MWcEVL+x4xc4xGZqY/URZFUvsP4k6r
	 RCi9D6YdkQ/zFFjN8m9yueaRsFSsu+FSIdgo3OpR+gNRnEOBE5d3wdj/0mZuvmg0tF
	 2h2I+7NLo5wx4a/NgVntlVFA8oJM6tB36A/z1lxTHuuzvrm+pOt24UQXRPaGFuAQbG
	 tnSQh+0wf6Iiw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568E839E8A7E;
	Wed, 16 Sep 2026 23:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-2026-09-16
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178959961089.3323142.8312446968745652036.git-patchwork-notify@kernel.org>
Date: Wed, 16 Sep 2026 23:00:10 +0000
References: <20260916083642.110609-3-johannes@sipsolutions.net>
In-Reply-To: <20260916083642.110609-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Sep 2026 10:35:55 +0200 you wrote:
> Hi,
> 
> First pull for this fixes cycle, I missed the cutoff last week
> and was catching up from vacation before. Quite a few changes,
> but mostly syzbot and/or LLM fixes.
> 
> Please pull and let us know if there's any problem.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-2026-09-16
    https://git.kernel.org/netdev/net/c/fefaac1176bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


