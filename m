Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE7938F935
	for <linux-wireless@vger.kernel.org>; Thu,  5 Feb 2026 10:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770287318; cv=none; b=k+1Bw48ZjIP9xCKzWKl+WzF7W6/+kSqHmMyqbnGVWY2/np9/53DSO3x24/TYa88+0s/mZ059TAfR24JYKlXW4vYzpbCcLvuFqriq0vFBe3KxFoxUpbS3F+K2a6TUSUvloQ1UlPmQT19Ev+MCIL5EzFGIQgfGTSDZ3QDSHzEnr/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770287318; c=relaxed/simple;
	bh=dNu1/Lg5TxbyQyNcmip10sTxpQzzRCTTd5FBT3t3N6g=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=iBKEoA7+XUu0Fl24lg1iG9DJQODWwGj4ruHwtf9Lb5TcpY2P8Nk1kncO7K5Uo2ZWZWsronGoDJPmyzZxTpFf3pSRALCJ4Lt97xTcgRflab9lgMiM1xnnSEzoJth8eyj2hlcNgcMG9nVZC/GqSLpJzt5SHsAahyMfRHhO4VKrzug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=PC+31grt; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="PC+31grt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=dNu1/Lg5TxbyQyNcmip10sTxpQzzRCTTd5FBT3t3N6g=; t=1770287318; x=1771496918; 
	b=PC+31grtZkn1HL1wlg3MO3f3f5m0cFSRofePUQKhN105diS4QDx1Yqx6EKlFPqwjcBGkbBSypHr
	VkIhmBsL4ZfiZNLCz39x2on5bkkAfmWpg/vBdI7deJGyOIpuJAw9k09HYsOjpwjzZSPP+Iuj/fhcW
	eg9d5VlJ6cMC6UNLpcQS39hF4g6iuY+1b9O27HEi1lgSGEOJ1P0ZTfIBHP2VJvwMZIlEpsTdxwq/5
	fPSlUPsEavp19QRz+kvwFRRq4+eYrib1cAvYBNt2RyyzXMiKY1s/b6bGWbzQX3JrtM++Hrdr2bg5s
	DTz7jL8RbIECO1iW7vISEwipMk+ScuGvaj4g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vnwb8-0000000FTqz-2D4H
	for linux-wireless@vger.kernel.org;
	Thu, 05 Feb 2026 11:28:30 +0100
Message-ID: <2edc78e3581a11c18189b1ac5ee95b0600586f82.camel@sipsolutions.net>
Subject: bot results missing in patchwork
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 05 Feb 2026 11:28:29 +0100
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

Hi,

Just noticed now that evidently when I did some server shuffling
yesterday I lost the job that uploads the results to patchwork...

I can't fix it right now, so for now just wanted to say that it's
missing and that I'm aware. I'll get it fixed soon.

johannes
