Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96AE2D47E9;
	Wed,  2 Sep 2026 02:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788315858; cv=none; b=L+vQ1reVLbSs34wyh2TGJpZPthEOB/3Babb8OwdsdbFIlB+MKaSjRvrRJJ7xpM0c6gqXfSC4Scq1nv9sehggTOFSsoDSPDQ4d76ahC5Hr0BUUHzGpJzoKiH5B8sQ0z9ErQmlnMQUvSKps/4ebMRoYetkHdLqN4Iyn7NJYWZ6Uo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788315858; c=relaxed/simple;
	bh=vyv1xPA5d37kxrKk1GJqBswZ+LYSHNuysTlYRQdsNvY=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=T1M6/HmqcyuVd2sUG5YkpwU5ajmK9bqNh0+Etusd1BY2vrTtoGPvk6Y5FqL3DhQRBOo8e/9jXZLCiTZatwBRH7VjREjpukQiqWIH/+o8Zu7NDQ9WgkfiYadO5xF2ege9wqeesq0UlrSlKv6xHbiLCcQwZ3M/EuBrjbSyUjBoU6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=a/6bKkhT; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="a/6bKkhT"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6822OC2202245449, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788315853; bh=06BprCopKlxZDDN79FrKhR+/FBrBB7keaQyAQZtVs8Q=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=a/6bKkhTrHaeqa7ZmL4n86WtsK3bpq4kjfRK8a9cKKXuPOAj2jBYhRXGOHEVQlcNs
	 dAFU/DQ97bik7WP1PC0YGHb/ATzL24AN7ZqJc0g7rJaIyFXEwqPkFnQTj7gVecw6m/
	 ETQJDEujqbNvpJ5ON2Qgj/gbrJKSQrxTvgqMLG9BTSWb+NxfvWW9k9Kpd6ccfv40u2
	 wBt//ujitj0kWAfa3ti9PYxO0mMO6JWX8c3isaXxJmURZlei6VzCu6V+Jsq+hY0CYF
	 1b8sn7lb9e/O49vRpDtPwMptuMax34ISnb378i/saOlUHtw9cgMC7kZNZPIifi6kMV
	 dS3WBs/w49P5A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6822OC2202245449
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 10:24:12 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 10:24:12 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 10:24:12 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Colin Ian King <colin.i.king@gmail.com>, Ping-Ke Shih
	<pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] wifi: rtw89: coex: Fix spelling mistake "verseion" -> "version"
In-Reply-To: <20260804095832.784121-1-colin.i.king@gmail.com>
References: <20260804095832.784121-1-colin.i.king@gmail.com>
Message-ID: <8fd1c489-6057-4dac-a080-2e9e63f6e0c7@RTKEXHMBS04.realtek.com.tw>
Date: Wed, 2 Sep 2026 10:24:12 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Colin Ian King <colin.i.king@gmail.com> wrote:

> There is a spelling mistake in a rtw89_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Reviewed-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

5628372f8fea wifi: rtw89: coex: Fix spelling mistake "verseion" -> "version"

---
https://github.com/pkshih/rtw.git

