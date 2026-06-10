Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439243BA23A;
	Wed, 10 Jun 2026 15:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781104415; cv=none; b=W11VaOnZqEUWOOaryE/lWmJbuyP36TwXRXO0GsMf/rkeW76tv0QzJJFinxkz5JFbeBjcaCmjT9VHuY9Fy4CUHpYStQ/ADw36Mk01A37iAwNgvKxAqcleyCeCg9oNvKMDhl3Fx+V+tFcpw817pnsSTdlnCCNOAnX0nPfAKdLxpHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781104415; c=relaxed/simple;
	bh=zUOpqkRYY5NB6Ww3f4SPFwVRAv2IpLaM7Tpk+Ut1zVY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=NsiN+DaWlfi2wdOQVdRiTZegMlwY7Rznf9imWaQgEAmFiDpove7E6OgSOq6bQ30S2wKSvN1GkWitkRq35K+8Wc7TxLT2/veE2ViygCOmJt89xVAr0fCBnr+iO8ML6TZa9ohbMqTkRahFqGsxK8OhW+BLjwR9pZT9lO1kd+xobf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gN7WIDPt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gN7WIDPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE431F00893;
	Wed, 10 Jun 2026 15:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781104413;
	bh=PHKfes4v8KNvDYJAPgeKqEirYXH9lAofN2epi6z8oMk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gN7WIDPt+6Zjmf4g7DaLWkUVjcJBIfimxqO69wQ05p3s6gvRRdMr3kRidgeF+jLzh
	 3Y3zp5B4Vt/qBzG1wY8iMB78Zg5cErDAHSCjSDUuscrfjnohbxGVjF7AnNwOcKsF8i
	 UIc6Y77ZcBiDPrCyVmkUqf7m1vhjisou+a00077sh/ABXnQ81OjOfKZEI2eXE3KbTW
	 rVKJx1zTYZDfXr3g4jYm56F+hxWhk9cMr5/PbjRqc74x3ZVDxKAsHlIifuh+QFdJip
	 wsREX7lAnnSxPC/macxH3bqqxQ6M84o+Gg7TgUHyFfXtSgwWnMw82sY6dXEZrX9eGn
	 Ku/KZv6Swwwtw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F08DD3930D5F;
	Wed, 10 Jun 2026 15:13:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-next-2026-06-10
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178110441164.3082243.15047843183218775795.git-patchwork-notify@kernel.org>
Date: Wed, 10 Jun 2026 15:13:31 +0000
References: <20260610103637.179340-3-johannes@sipsolutions.net>
In-Reply-To: <20260610103637.179340-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 10 Jun 2026 12:35:39 +0200 you wrote:
> Hi,
> 
> This should be the last PR. Quite a few more driver things came
> (see the tag message) but otherwise it feels fairly simple.
> 
> Please pull and let us know if there's any problem.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-next-2026-06-10
    https://git.kernel.org/netdev/net-next/c/972c4dd19cb9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


