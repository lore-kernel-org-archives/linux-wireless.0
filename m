Received: from mailout08.hostingdiscounter.nl (mailout08.hostingdiscounter.nl [91.217.57.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E8A15D1
	for <linux-wireless@vger.kernel.org>; Sat, 24 Aug 2024 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.217.57.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724520726; cv=none; b=Yfm0YCKpG0/3Bbc37YfzpYOn3dvQRP9wfaoNpzvOcaBQMUhXWgeHBba4y4U+qAdrzF8m9ItzhZOT9RUU94i5sXzKoJRVoBbgcIeBOc93prpARHp5k4SVtSCefXOXj5pFYwHMmGpy8oLDGc3NSa9n06XO+oV/uONgohPc2PJd2MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724520726; c=relaxed/simple;
	bh=tC1UnAvbA+GLygfELoXMYeX2l9uFG341v7WIkawTa1Y=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=e2GviTC/ryp3/DxNGMv+aNWlYHgQbFr3Keuf9yW3x7CEuE9unqoGMKOw94mw7gzs3HHWQkusmJFXATxH2+6AVE0JPYtM+gHdoQTkPrGOsS1qb+YYMEw3/OmqFTW+LZR3cX4h9xHcrLdSQBHMs1bayn6nD1/Jsf8m6oLQIupICyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zeilsteenfilm.nl; spf=pass smtp.mailfrom=zeilsteenfilm.nl; arc=none smtp.client-ip=91.217.57.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zeilsteenfilm.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zeilsteenfilm.nl
Received: from localhost (localhost [127.0.0.1])
	by mailout08.hostingdiscounter.nl (Postfix) with ESMTP id A550D20E;
	Sat, 24 Aug 2024 19:31:57 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at mailout08.hostingdiscounter.nl
Received: from mailout08.hostingdiscounter.nl ([127.0.0.1])
	by localhost (mailout08.hostingdiscounter.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZEC5viERz33h; Sat, 24 Aug 2024 19:31:52 +0200 (CEST)
Received: from mail226.hostingdiscounter.nl (mail226.hostingdiscounter.nl [IPv6:2a00:1478:20:0:7:770:0:1])
	by mailout08.hostingdiscounter.nl (Postfix) with ESMTPS;
	Sat, 24 Aug 2024 19:31:52 +0200 (CEST)
Received: from smtpclient.apple (unknown [45.85.220.52])
	by mail226.hostingdiscounter.nl (Postfix) with ESMTPSA id E59CF5E434;
	Sat, 24 Aug 2024 19:31:51 +0200 (CEST)
From: Herman Zeilstra <herman@zeilsteenfilm.nl>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: RE: wil6210: low level sector API
Message-Id: <B15D4C08-31DF-4418-BD1D-FFEC66BBD2E9@zeilsteenfilm.nl>
Date: Sat, 24 Aug 2024 19:31:50 +0200
Cc: daviddean166@gmail.com,
 linux-wireless@vger.kernel.org
To: dlansky@codeaurora.org
X-Mailer: Apple Mail (2.3696.80.82.1.1)

Hello Dedy and David,

How can I call WMI commands in the code of the driver or from terminal =
to get the active TX and RX sector info?

I would love to use the beam tx and rx info of the wil6210.
Tried all sorts of debug options to get the sector info in the source =
but with no luck.

I do get the debug text but not able to get the sector info out in the =
kernel log.=20
Placed debug lines everywhere I found secter commands in the cfg80211.c =
of the source of the driver.=20


Many thanks

Herman=20=
