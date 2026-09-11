Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CA325776;
	Fri, 11 Sep 2026 10:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122260; cv=none; b=UpGG6OEq9CiiklWBGKGRSJOc9noDOuH118KcKILv1uoT5edco4ka3EgPRtCMxPr7oA5w5Cvatuqo3QZoMo8YWgM/pYTlwvDcu8DtrtQIPf49CoW5sdyP1mTy5xvL2J1IlYQdT8FcvXfQh/96+FNcxt2bxGTuYtc0RziiYE+2JLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122260; c=relaxed/simple;
	bh=UJGToeUwHmwkd1HTGOWYUK4UYnvnmiY7xlyS5858pJY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=n0i7ZxiANZ+R6jbXTkFbBySFviV3rvbpn0HTnl0NltQzyNqdzoJNSn6yRi/CWR+KnTLeg7orWOS9vN6/4qF5CJSjuZs1ZRHP4iss+5nZRIVV2VU+ohD9jov4VbcLMrmGLRT9be1zRPn0kPm+HRPLT/YTiRTA1K7fjVwGQ/hiqZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: ath9k: fix typo "upto" in comments
In-Reply-To: <20260904105313.33238-1-hemanth.selam@gmail.com>
References: <20260904105313.33238-1-hemanth.selam@gmail.com>
Date: Fri, 11 Sep 2026 12:24:11 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87v78ccchg.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hemanth Selam <hemanth.selam@gmail.com> writes:

> Correct "upto" to "up to", reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

No thanks, this is pointless churn...

-Toke
