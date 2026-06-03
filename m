Received: from mx17lb.world4you.com (mx17lb.world4you.com [81.19.149.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D16368D51
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 12:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.19.149.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780488024; cv=none; b=sSVfXNDWaSWA1Z/IDJz/4J4lBwEvMJeL9K/IUI6Q8KNjC1A3vlah3Pxw1bp923QfkHFxNGfP7e9muy5AEmxcvSdoGo1td9RQgwfx3HuYi53LtigaXblbVBKrLdW8aoKf106DoK7vlDhZsIlFzKrA1aL3e2fu9jIJd73sXFtIBGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780488024; c=relaxed/simple;
	bh=9q183NFC9fS2JbtBL36Ugl1YrAbf8Ci2YCyn/eMtdUU=;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type; b=fpvrv2ZGF+CoUvs+Me/C+5ROymOhesp0wh+cPynk/R9YlZ4pIDr360G/lVOm4utJKhmGj9icyDTDZxyuaDW2G/ht/qp1hc3yHJv58dRS11hCEMLi99YS/zzLh13JhoOqjEuAD4Yf2Rx13bEUk2YUfGFiB4VPUEmi901DEJhplnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ciaorelated.com; spf=pass smtp.mailfrom=ciaorelated.com; arc=none smtp.client-ip=81.19.149.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ciaorelated.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciaorelated.com
Received: from 89-26-47-193.stat.cablelink.at ([89.26.47.193] helo=[127.0.0.1])
	by mx17lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <info@ciaorelated.com>)
	id 1wUkGi-000000006e3-0l2M
	for linux-wireless@vger.kernel.org;
	Wed, 03 Jun 2026 14:00:20 +0200
From: Dogan Karaarslan <info@ciaorelated.com>
To: linux-wireless@vger.kernel.org
Subject: Open source social media project from Salzburg
Message-ID: <b6949391-f359-fcfb-e7cf-61564fb628c4@ciaorelated.com>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 03 Jun 2026 12:00:19 +0000
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-AV-Do-Run: Yes

Hello,

I found your contact through GitHub.

I=E2=80=99m a developer based=
 in Salzburg, and I=E2=80=99ve created an open source social media project =
focused on communities and meaningful connections.

I=E2=80=99d love to share it with you. If you like the idea of an open =
source social media project, I would really appreciate it if you could take=
 a look and maybe star the repository.

I=E2=80=99ve put a lot of heart =
into this project, so any kind of support, feedback, contribution, or =
simply sharing it would mean a lot to me.

Here is the project:
https://github.com/dogankaraarslan1/ciaorelated

Thank you for your time.

Best regards,
Dogan Karaarslan
