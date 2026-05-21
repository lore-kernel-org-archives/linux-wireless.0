Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8783F0A9F;
	Thu, 21 May 2026 18:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779388217; cv=none; b=PlrgsZ+QR/zF5qNHJZxpD40yeJsmdGALT7OvvYV65zKiTXvKfwNwL6h/D/Qsuv8dYD3YnHE30meOtQhV1dghmIhUVzTD9SA1/DBMFI9uMNh1BC65v0JClUha3Uev5NxVjl6xxN8mxOvfZN5wkTOxJDQnijN3AP/dE1mabTXhez4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779388217; c=relaxed/simple;
	bh=bNkRu+dRHQKnOGdUbRNtCKXE/+2y99/uykwJK+GPUUs=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=t+JSMM9KYa8dUOcJEM15uB4ggL2j3nFTjVioI6jf9J5r3RgdjaHgDjQY05Zl7aWZi5IXTR9Tdb74FXzxos7aOPC7DV+UO6w49wxoYlqr29OEyKI15hbfGBS+n1yQ+vUFFMFupK/jFnen1Nhf0ZFkgL1vrM1LFI2AOx8i3uORV1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=icpcUQE5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="icpcUQE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CFB1F000E9;
	Thu, 21 May 2026 18:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779388216;
	bh=8pXQIOYsd3TiGKcmNoBQkfLMFM8Worhmkeb8MiwZJPc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=icpcUQE5a84I68RKKgAOEsJFuOUhCng44LntG7T98XmjnSEQe3KsjqWhs3qlOekcT
	 0HpomahcecR2RmywvPhMLhUT1hp1nncANsD7rPRi/j/mqhooOLs83GuwifW0uCOxvz
	 YrBsFlo2C7PiMeNZOl1V/DIsMhr4tpQpwI0kvpwP/1Kl+byVFyT6x6lwHJK36AFPvR
	 8GS0NWhaLl9nJgFC4gV+cth89K8yGtLJybm+mgiGFbbDgQp/pP4Qd7jxYn/umrjsx4
	 84Frh3u+ChVi5ltz2uY8Hg1JVpkUiP0i9pK98vnw01yrriqGckPTeVZp5W/OZ2fgaC
	 uy5+7IgxKMWYw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A763930E2D;
	Thu, 21 May 2026 18:30:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] wireless-2026-05-21
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177938822639.479856.455595789879193535.git-patchwork-notify@kernel.org>
Date: Thu, 21 May 2026 18:30:26 +0000
References: <20260521152903.374070-3-johannes@sipsolutions.net>
In-Reply-To: <20260521152903.374070-3-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 May 2026 17:28:37 +0200 you wrote:
> Hi,
> 
> Sorry for the last minute thing ... if it makes it at all.
> I forgot during the day, and it's already more because we
> had a holiday last week.
> 
> Please pull and let us know if there's any problem.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] wireless-2026-05-21
    https://git.kernel.org/netdev/net/c/0e3c08f1b7b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


