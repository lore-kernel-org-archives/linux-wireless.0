Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1188549552C
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455190; cv=none; b=fPgHfEJ/HByAp62nTKi32k78QuzxP9oAxStKblbRFnV4b/1VU9UTv6dx3li+3Ca3jtPc+pXZ+9nW9TypvU48KByxXb52jOvvt3u4v1oUgKcCPlaCeWOwd7Ssj5nIdIFMGBAjU0mCnVS8aem7R+1FpZ6Hx4bz5jNaflPErGTJnzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455190; c=relaxed/simple;
	bh=i+F/YS0Tvvz3wSTNke6zXmK24kXIkaoLB4AiCmseFSE=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:
	 In-Reply-To:References; b=oq1dG5SqtX+nl8ISYz4VEkTRVDo0UOCpgFOSNXCyZJD3yp5qPJ0EVzvikX3FymU3Dar9+6u51/sSuzeUrqTw10yZiQG49GlH/pJKAZXKCF8ZSlnxNqHKhLyYJmsdoMchJsLb6KwQvtjOYzS1YF95UuyedhpXd2ZzP/BtXHKAKc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rrgiX09q; arc=none smtp.client-ip=95.215.58.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rrgiX09q"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=i+F/YS0Tvvz3wSTNke6zXmK24kXIkaoLB4AiCmseFSE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791455186; v=1; x=1792059986;
 b=rrgiX09qQHdhE4n1XVD9oAOnWZfnIuH/WkW8fiX3rUICOYYe4VpEI1TsBpFYphit5r9paN+U
 3/Mem8Y6glApuJiDLaN0WF6gvSRDXwf1LB/aZAbwQe9HjytMgyRLeSlnOEEu1u+uD7O2n0hYvHA
 16HvmF0Q6JM6SjATKJcwulPg=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b4bfddaf66fa9f35;
	Thu, 08 Oct 2026 10:26:26 +0000
X-Mizu-Trace-ID: b4bfddaf66fa9f35
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 08 Oct 2026 10:26:26 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <5a62749f42ea136f701eb99655ed6218a11920cc@linux.dev>
TLS-Required: No
Subject: Re: 2MB patch keeps resending
To: linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org
In-Reply-To: <a7ed4fb9e80efbb7f7bfe005a48569f75a3ac0c5@linux.dev>
References: <a7ed4fb9e80efbb7f7bfe005a48569f75a3ac0c5@linux.dev>

October 7, 2026 at 18:51, "Luka Gejak" <luka.gejak@linux.dev mailto:luka.=
gejak@linux.dev?to=3D%22Luka%20Gejak%22%20%3Cluka.gejak%40linux.dev%3E > =
wrote:


>=20
>=20Hi everyone,
>=20
>=20As many of you, who are subscribed to certain mailing lists, have
> seen, you keep receiving same 2MB patch over and over again.
>=20
>=20This is a server side issue not influenced by me and has been
> elevated to helpdesk and migadu support.
>=20
>=20Sorry for the inconvenience and hopefully it will be resolved in the
> nearest future.
>=20
>=20Best regards,
> Luka Gejak
>

The issue has been resolved by migadu support, and they claim it
shouldn't happen again.

Feel free to delete excessive emails and again, sorry for the
inconvenience.

Best regards,
Luka Gejak
