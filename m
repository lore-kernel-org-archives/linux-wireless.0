Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3572A40E8D7
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 16:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791391896; cv=none; b=KZII3YtFcePe3K7NihLkt1Bgert5jc4Wkj1U2NTb6yKr+hONn5fVpApP2If6hD+W8gLOlDXJ41duMa8C+gD7slXLOhqQDBz/hQcd46Tzk3n+zvE5APn2GkL8tghHbAA7SAaL7zXe3ExBrqEgc1Cx/22SXpH0DIERG3maipvcSEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791391896; c=relaxed/simple;
	bh=wfpM+HsGaMPDjFT4jmhDKqziOSkaFMtmRy/hAxYBlFE=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To; b=TxvLEC3yDhownApF874vL1y5VhO3VFNBRLbFfVFunZHw4WcIiQIP2vA9LSMB5t98yBQglB9dt9FCrSKGfEowPs9oglZYGvwwixSentHerohqySjaRs6Oy7B7vEafieaEcRWq5LOSsxuGq9kSw41GE2OIApcedpLA6WkKkBOnxf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lLpbddPm; arc=none smtp.client-ip=91.218.175.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lLpbddPm"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wfpM+HsGaMPDjFT4jmhDKqziOSkaFMtmRy/hAxYBlFE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791391892; v=1; x=1791996692;
 b=lLpbddPmX4eZHr0ARYafykOfBcwMv+es5InDLLV4FhDyhCVAt5uTCCAjbDghfWPWgXey24Jq
 r3x+uDXqq/5Wa+8jIixfzE6IdW+GYnt7n+DSX3D63axhVeuuWpVsYxL56XOyXOZrekIb4pybMbh
 xuS5iE+V22ZV9c4Y8xdyTMkc=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 24f5a2265a79b04d;
	Wed, 07 Oct 2026 16:51:32 +0000
X-Mizu-Trace-ID: 24f5a2265a79b04d
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 07 Oct 2026 16:51:31 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <a7ed4fb9e80efbb7f7bfe005a48569f75a3ac0c5@linux.dev>
TLS-Required: No
Subject: 2MB patch keeps resending
To: linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org

Hi everyone,

As many of you, who are subscribed to certain mailing lists, have
seen, you keep receiving same 2MB patch over and over again.

This is a server side issue not influenced by me and has been
elevated to helpdesk and migadu support.

Sorry for the inconvenience and hopefully it will be resolved in the
nearest future.

Best regards,
Luka Gejak
