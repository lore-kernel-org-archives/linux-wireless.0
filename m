Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650C433343C;
	Tue,  4 Aug 2026 06:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785825831; cv=none; b=BIHf9v0SGANuu8zFglhVYKJrBTVSDXyzVniNnksnqE+TegqdvbwvecsiJtEf8Xr+4f+Mrwy0iTpVAFgG+/N2mFVAn19hKO2w3+99gids+SiCjgV5/GBNujTxTeHS2q0HvgPQkHmBIn8lk4t3/YLz2A804Fl0X0N1nsI1ldKD6rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785825831; c=relaxed/simple;
	bh=F43pk5MLKFACc0bvCNwAlsXHoFaepN96N9hndJjyjCI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E21gu63RqYbqmity3Rfkq/OB3Br075Aw6iCctmU2JU4MzpT/Vb714kXE9g7KDZsNcnGX1BoqXob7xaYZsO3zY7mspf4Ea7sUEjpMGfXHuUNYRIbfNPL47oES0EjcERmeTWdrYajTQq/FGdfv8t+VZgXo6V/S1F3QGrC+UgOqzsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=jJAB+AF1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="jJAB+AF1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=F43pk5MLKFACc0bvCNwAlsXHoFaepN96N9hndJjyjCI=;
	t=1785825828; x=1787035428; b=jJAB+AF1NtGveYTux1XRPjvU3e6I1AFTa0B+yNLVuaKeCUW
	Pti4C+YGHYw01hJroYum4ULqi2ncbitMK8VcQ4q8ZzPEVaFIw0u63TTNYbgomAOxP7it+A3hCtpiX
	dwSXDdN0jxrdYse33YnM/Syq5NYzSkbvg1hAViSc4OgKWxdyQV/R5Jdl7XCQD3A/+0/dl8Mc5RAdS
	tp812OWTm7sXSjGbb+GrhHC+HResNaU/1vPBBFodu5hOlQVrFZY+hNePbvEYuQs5xfAaNmlfCiuAu
	iHb9AIpFQpZz7s1xtOsNJINwuX+Rw9sh3HdyC/9S2Bj89cMt0TkvNhh23SX0tK5g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wr8sK-00000004agm-33gH;
	Tue, 04 Aug 2026 08:43:45 +0200
Message-ID: <1bac92ad715390e4c9787913fc60f9f9a677515d.camel@sipsolutions.net>
Subject: Re: [PATCH 1/7] wifi: cfg80211: report authorized connect and roam
 events
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Huang <Jason.Huang2@infineon.com>, linux-wireless@vger.kernel.org
Cc: Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>, Chi-hsien Lin
	 <chi-hsien.lin@cypress.com>, linux-kernel@vger.kernel.org
Date: Tue, 04 Aug 2026 08:43:43 +0200
In-Reply-To: <20260804030450.232028-1-Jason.Huang2@infineon.com>
References: <20260804030450.232028-1-Jason.Huang2@infineon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Something looks like it got lost - I only have 1 and 2 of 7.
Please resend either all of the changes or as a shorter series so nipa
will process it.

johannes
