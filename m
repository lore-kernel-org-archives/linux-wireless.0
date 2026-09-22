Received: from mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669B531E848
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 00:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790037829; cv=none; b=vDokvpvrL4BzYxXwoWzv++4MmTbbftJqn2zfXNtUTjYN6G+7iupCPoFanp282J404C+ZQ/SU6wkoXMDO+835EwVJ6cHpgiE/rE1CwFN75nd9ZQdnl0R2Y/gVZNHP866HIuwHjI9NHJaoTQxM6c9AV48sgjU09iFwr3ShXBLn4EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790037829; c=relaxed/simple;
	bh=QsLbACK42qC4IHST6bqM4DHpYPHMgoDT89jU78WvzJ0=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=jJ2RuvNmf14kP6Pc+snF7HrdE+duaKL/cNaf2G8CogulesYbICt4dlhwYhUGTXfbRI7pGrdcLd82p6B7aRJ//lbMDS8gF8N56uHzifysN2ZYXz/Dc56B/17V6Zu1C8KMt8T3POpLm7kNNTcts9KgXcPDGA3hzW+BjGeYsA/Zc1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nT+nJMjb; arc=none smtp.client-ip=95.215.58.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nT+nJMjb"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=QsLbACK42qC4IHST6bqM4DHpYPHMgoDT89jU78WvzJ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790037825; v=1; x=1790642625;
 b=nT+nJMjbNWg0tssJ1cScJz7QJDTBsIgy7YgopA+XFCEZMh0xCmIlWWKduj4DQFiSaljEj5T/
 6yjFEa3HHx1GK6fJo/93abYoxKJ0YpW2RDi0pIb3nlu5g0Yz6gnQ3Apmhg1uP6NH71qSSTbKkjJ
 3Wl/IRZ8lRyoJ4a5W9NdhL/I=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9fc6d37b03a19712;
	Tue, 22 Sep 2026 00:43:45 +0000
X-Mizu-Trace-ID: 9fc6d37b03a19712
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 22 Sep 2026 00:43:41 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <c419df59280e52baa5e25f665eff599592f3cdff@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Jeff Johnson"
 <jeff.johnson@oss.qualcomm.com>, "Johannes Berg"
 <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael 
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <fe3c6884a96b476799f415a06314f1ba@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-7-luka.gejak@linux.dev>
 <45eb7d5908f8fff9a18cba603fd3a4abfe8695f9.camel@sipsolutions.net>
 <31285267ebc43aab631a4199059a247a8d937814@linux.dev>
 <c208152fc5cb45e19ae7d4660394dbf2bc5e0271.camel@sipsolutions.net>
 <bcd5a280-8184-4457-ae52-47a9e0fe763c@oss.qualcomm.com>
 <ffe834a8a469d5febb7e73de371d662f9a0d115f@linux.dev>
 <fe3c6884a96b476799f415a06314f1ba@realtek.com>

September 22, 2026 at 03:28, "Ping-Ke Shih" <pkshih@realtek.com> wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> September 22, 2026 at 1:35 AM, "Jeff Johnson" <jeff.johnson@oss.qua=
lcomm.com> wrote:
> >=20=20
>=20>=20=20
>=20>=20
>=20>  On 9/21/2026 11:14 AM, Johannes Berg wrote:
> >=20
>=20>  >
> >  > On Mon, 2026-09-21 at 16:49 +0000, Luka Gejak wrote:
> >  >
> >  > >
> >  > > It is supposed to work in the same way it works for other driver
> >  > > maintainers. I would review patches and provide my acked by or
> >  > > reviewed by them and Ping-Ke would apply them to his rtw-next br=
anch.
> >  > >
> >  >
> >  > I don't think we have a lot of folks below the driver maintainers =
who s
> >  > end me pull requests (except Toke maybe?) - but as long as I don't=
 need
> >  > to deal with it I'm happy, you can figure it out between yourselve=
s :)
> >  >
> >  For ath.git there are sub-maintainers for ath5k (Multiple), ath9k (T=
oke),
> >  carl9170 (Christian), and wcn36xx (Loic).
> >=20
>=20>  Toke has a linux-wireless patchwork account so the ath9k patches a=
re initially
> >  assigned to him in patchwork, and he Acks on the list and assigns th=
e
> >  patchwork records to me when he approves patches.
> >=20
>=20>  For the others the maintainers just Ack on the list, and I take th=
em from there.
> >=20
>=20>  So the question is do how do you want to handle this in patchwork?
> >=20
>=20>  /jeff
> >=20
>=20>=20=20
>=20>  What do you think makes more sense here: patchwork delegate
> >  access like Toke has for ath9k, or on list ack based? I'd lean
> >  towards delegate access if it's not a big ask on your end, but
> >  happy to go with whatever works best operationally for you.
> >=20
>=20I'm happy that people join rtw88 reviewers.=20
>=20
> Personally I prefer people give Reviewed-by tag to the patches, and
> I can myself take the patches by patchwork state and send pull-request
> to Johannes.=20
>=20
> With additional flows of patchwork and pull-request, it looks much
> hard to maintain, since I don't think there will be a lot of patches of
> drivers/net/wireless/realtek/rtw88/rtw8723b*.{c,h}
>=20
>=20By the way, if you are interested in rtw88, maybe add a "R:"
> entry to be a reviewer of rtw88?
>=20
>=20Ping-Ke
>

Hi Ping-Ke,

I agree that approach is simpler and I am perfectly fine with
it, if it works better for you. And about being rtw88 reviewer: I
would happily take that role, so I will send a separate patch
outside this series.

Best regards,
Luka Gejak
