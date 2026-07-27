Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2920E389E1A;
	Mon, 27 Jul 2026 23:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785196742; cv=none; b=IQ4eULVofql2JOhwcqvhWwE66ewKOL3fdS6Q6wlLZfndZLod46Dxeij6PB/bhepAQ4/cQJ+G7RK5xnPdgIUJY2P2TtXYj3Ns8rPKQewLj0Z4CVnhGYTB0zOUd3TRqvj6+Bg036RAm2MjtqjfMCOGiK9/QpBia1LGAwdInTNqaF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785196742; c=relaxed/simple;
	bh=MNHDM2/ziqQDW95KvQ+WM3OrkGMrzc65sAqUHEcCGh0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZkEINkiIHpgJuufkDPGuJzqeFlhE04YVZAHLwgmgWp+QLILgeAP4T6vWHYAi5OetEytglWG2+CnpUWZBR1nsKASDlhrCuxYtg0glPzG/Wnm36+6Tj3Twm7Hd8GuVUr4TsarzKk8tLNmHlQ/qwJaQKxaMoG/DvMlxk5rJDldYHBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFp7agOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFp7agOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16D41F000E9;
	Mon, 27 Jul 2026 23:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785196740;
	bh=MNHDM2/ziqQDW95KvQ+WM3OrkGMrzc65sAqUHEcCGh0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MFp7agOE943LK7xlk5BQvx95Eyl1fGTi7PKHp/wb8ab+busqxbp3vP2aB7t2uGVle
	 Ap70Vs38CUjg8L+VOQ8OBeMOGepXj8xP9w/boIpqcRkFo14EiFlsASVnbSm7xRYRL2
	 /zBbOb2ArvYIMF7SW0wGgr4iSNxWGKs71NNYfnsuGUC6BCFN/aPObs9qqOoCk8hJBf
	 ZLMoZyNLIzaZdBeLvW2D5Bx9O5tg7Ilk9kOaUOF3n/f72vXlgqJlWaObZ+/wyETUCN
	 O1UNWW4CZH1tXAHHjEqOMH/+IJlZQFZHohfZBCRlz8dnZvyScBC3T/yF3en3hfxz7Y
	 kVWlasad3Ig8w==
Date: Mon, 27 Jul 2026 16:59:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [GIT PULL] wireless-next-2026-07-26
Message-ID: <20260727165900.476f702d@kernel.org>
In-Reply-To: <20260726105205.942922-60-johannes@sipsolutions.net>
References: <20260726105205.942922-60-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 26 Jul 2026 12:44:42 +0200 Johannes Berg wrote:
> Here's a new pull request, big simply because there are two new drivers,
> otherwise nothing exciting is going on (yet, I have plenty WiFi8 work
> in the pipeline, and so does Qualcomm, I believe).

The merge seems to have confused the bot.
Pulled, thanks!
