Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C233264D8
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 07:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780472209; cv=none; b=IluxaqctMeDFMz4dUykSpQBnHUNOh0COl90ZQal+xU6YsKTFqz674IKg5Csm53lpXTUoL+UbPx2ZNlr+LUfNI3l1U3jN+ShtFlsXxVsHH2M7MHcLkJoM6GlcE7+RzaNqshmpIbDF9hjiyNmgKVF24LU9/87D2Cx/oUiQvwxlosY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780472209; c=relaxed/simple;
	bh=d5SttnKcjxO3u1x92Al6rAlnHGpPKWq5a0Nn76f0k3o=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=B53fb+QNsvT8NHNBo+Xi/Ud/Iu3Sxng6CmCQipPYeY/87csrAkjB+aMY61Yx03RZbe4RYbeBQcCtZr8TL62VnNO2lXHGIZbsiVRITOwPg6kf2iuVSbKcQfbodfrlpjGeQodaWmWTqWU15snPHx1ZRyHVnd0SpklcUFR6sjWweQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=lSW5EsE8; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="lSW5EsE8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=d5SttnKcjxO3u1x92Al6rAlnHGpPKWq5a0Nn76f0k3o=; t=1780472206; x=1781681806; 
	b=lSW5EsE8JVqqn0SpkS/ZaMLv1d/j+xJYPHYolBLilhMbZyOLJVb4R15jsdwhrerUKW0nn0ODd89
	cYWBXyA60YedDPwAfcSxHeqX1HnpETsovTnZBy8XR7o2GFFDX/r3/Q7U3Kj2Ma9NW7BY3YwHNscbJ
	G8bUF1CKDMJOkrGV7DbXpkz+iohHxH3FLxGXhkim4WtqYYc/kIBEdTcXQLkvBJEHnA/1sxEJzBTZj
	XgZLmQ1NUdWqtXpVbEkj87kxdYIt/k3bxNSPAu+BA2tDCP7eXNUNpL6bfJo7F/vsRxQzxCf/ww6p6
	lvZchoZp3GO3Kok3/Q02fGEPzYkPKj3HZNLQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wUg9W-0000000Gx54-3pWj
	for linux-wireless@vger.kernel.org;
	Wed, 03 Jun 2026 09:36:39 +0200
Message-ID: <49053d2520d891e7bb3bbc69e596ffdb76462cd2.camel@sipsolutions.net>
Subject: =?UTF-8?Q?=E2=9A=A0=EF=B8=8F?= wireless tree rebased
From: Johannes Berg <johannes@sipsolutions.net>
To: Wireless <linux-wireless@vger.kernel.org>
Date: Wed, 03 Jun 2026 09:36:38 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

To drop a commit that didn't have proper S-o-b, I just rebased the
wireless tree.

Sorry for the mess.

johannes
