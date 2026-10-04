Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B3243B3C9
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791121324; cv=none; b=likXusXCMcloXPJu62wn6S8ATigAbPqVPIhCSiKXwwqeV5eDBCzebon+3/G+lkam9iGgeIyqgS5Cja45XD0FOpZxhUoKjENPOk/wFt5WYg7iylJM6SKMflcyQf6Cu2T3M4rSJsjftsQWIGv8aLSOBCRHvHfArWqgwak5FpOShvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791121324; c=relaxed/simple;
	bh=JgRcvycg6bpiwMU6pc3stmGnNYYZWJbtotZwvWvRzjY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fgB0IzAhBbaKuFa3xq96XkOF43u8wReiekhDJRRrl8YasyjmQfV+DL0vBIG3kPGvUDFxgkzihmf+0D4ejFXcfDXaFombFHhp21hRoT7VNvVsX0wq328dvuKkwZdNg9Q5NGXQxDmtEbtDWX55UqjJr/cwtD1k2yifGQmbVwkSqZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=c7D/JqEh; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="c7D/JqEh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=JgRcvycg6bpiwMU6pc3stmGnNYYZWJbtotZwvWvRzjY=;
	t=1791121322; x=1792330922; b=c7D/JqEhYYZOJ8JfXznuioTxdsxUM/ZGDOA4JoH+UjaT87D
	1/sx0U05U7ekjg5b/wm+jD4PO14IRs6AsYG9MqF2hSftZ8Zm0CV+TQkjvrMARK3pYiLRyBDQnaaNl
	pav/YaBNW7w2/bkZnnq5wEd+2d6tE5o6NN9fiRTHyHpqO6XvfyO91cYQ2moTvEnrLtPcAZdEv5S8D
	X8lVCTySlExFJJ+0jF6OCscwYOKAjf6jiCwpEm1RuFS7415rzrWiUQtNckRPnsUQub6aE6+AcllfK
	/DXOewDJB0bu3JHFHTtooYlsrX9jzvj75gAj7muA6TAgq2U50gULdn26XEGnQSyw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDMTX-0000000478d-1nb7;
	Sun, 04 Oct 2026 15:41:59 +0200
Message-ID: <696ff630bcdc7295d9de88ad7583b9aa136111f3.camel@sipsolutions.net>
Subject: Re: [PATCH v2 00/11] wifi: cfg80211/mac80211: add NAN Instant
 Communication support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 04 Oct 2026 15:41:58 +0200
In-Reply-To: <20261005074037.3506633-1-ilan.peer@intel.com>
References: <20261005074037.3506633-1-ilan.peer@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-10-05 at 10:40 +0300, Ilan Peer wrote:
> This series adds support for NAN Instant Communication, including hwsim s=
upport.
>=20
> Changes in v2:
>=20

They also no longer apply?

johannes
