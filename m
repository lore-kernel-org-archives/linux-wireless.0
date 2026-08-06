Received: from mail3-167.sinamail.sina.com.cn (mail3-167.sinamail.sina.com.cn [202.108.3.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE91D21CFE0
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 23:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786059028; cv=none; b=o78F0Efh9EtNmpFoaAw3SljtOThsxFFqOsPYP6cwjxHOpqtwWLid2oZGU0yUuS2w8rwufYH3JtvKZJHk+zxSeqycMxtGZLfrilftUWb0Fa/SwIdYpLWgpIUvVU+h91HXgbAAFHFqYBo8q4pI2ASfBMBIvYQli39x73C+IxiVvnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786059028; c=relaxed/simple;
	bh=LLPIVZLkcDBEXmcY+m6qHFAz6hVv8iBq31NdOIuv73Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBkgeaTGr++sAQPudXmpDxg6QROoy/qmCbb54qbmWYZ6QdyGNxKnqmjrt4HOCEudOlZk8RyCOq/0yidLcSokbIPhRbUdZJ0veROmJ3CvR2k1uS2khytfUpD4VOoEq91iHvB/axaPVDPboEuAzFmsM/2NL4GuUJEdoHHUoAwX0sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=m2uT1+EL; arc=none smtp.client-ip=202.108.3.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="m2uT1+EL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1786059024;
	bh=LLPIVZLkcDBEXmcY+m6qHFAz6hVv8iBq31NdOIuv73Q=;
	h=From:Subject:Date:Message-ID;
	b=m2uT1+ELOFl7gN3p6cwL53qRiUYlCUAZatEi/9glIP7bFLq/m1aBcujD+pqurubcX
	 KVxwPw5FDKBN28CRiiPafQDu9Vpv/d3O09Vl4q/L+UQ7cj0bkAdjuCHbI2SNh6f+2X
	 VA94R3kysX29ORPs4X0DGQKfcqUzNh/QaSWFaHT8=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([221.216.154.155])
	by sina.com (10.54.253.33) with ESMTP
	id 6A75190300000BF6; Thu, 7 Aug 2026 07:30:14 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 5296506685417
X-SMAIL-UIID: DB663BE915C8410096AD3F36CA1047D9-20260807-073014-1
From: Hillf Danton <hdanton@sina.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Slawomir Stepien <sst@poczta.fm>,
	Aleksandr Nogikh <nogikh@google.com>,
	syzbot <syzbot@kernel.org>,
	syzkaller-bugs@googlegroups.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>
Subject: Re: sysbot AI patches and wireless
Date: Fri,  7 Aug 2026 07:30:00 +0800
Message-ID: <20260806233001.997-1-hdanton@sina.com>
In-Reply-To: <8a0020fb5318ed645b0331d3790a75f83c0ee443.camel@sipsolutions.net>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 06 Aug 2026 16:49:45 +0200 Johannes Berg wrote:
>
> It's definitely part of the job to train new contributors, and it's
> actually very rewarding to see someone grow from first time contributor.
> Sadly, now there's basically no "first-contact signal" that says "I care
> about this more than landing this one patch". :-/ Getting a well-formed
> (and well-argued) patch used to be worth something, now it's basically not.
>
Nope, who cares (LPC/Unix)?
Is Linux helping make the earth a better place (for who/all)?
