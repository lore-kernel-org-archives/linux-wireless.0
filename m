Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:3069 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZD1PyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 11:54:01 -0400
Received: by wf-out-1314.google.com with SMTP id 26so436432wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2009 08:54:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <30715795.1255391240909093356.JavaMail.coremail@bj163app124.163.com>
References: <30715795.1255391240909093356.JavaMail.coremail@bj163app124.163.com>
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Date: Tue, 28 Apr 2009 08:53:41 -0700
Message-ID: <43e72e890904280853y419b9dcfw13722345892fa9b4@mail.gmail.com> (sfid-20090428_175414_747526_F9E58EAB)
Subject: Re: Question about 802.11s(mesh)
To: =?UTF-8?B?6IuP55m96b6Z?= <subailong@163.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/28 =E8=8B=8F=E7=99=BD=E9=BE=99 <subailong@163.com>:
> Dear Luis,
> =C2=A0=C2=A0=C2=A0=C2=A0 I'm a=C2=A0undergraduate student from China.=
Now I'm doing some work about
> 802.11s and have learned a lot from the =C2=A0web site=C2=A0linuxwire=
less.org.Since
> I'm a beginner, I=C2=A0meet some problems,and hope very much that you=
 could
> give=C2=A0me a hand.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0My question is:"Can all of the wireless=
 networking cards=C2=A0run in mesh
> mode?" I think they all can.=C2=A0But =C2=A0why some can not=C2=A0as =
it is described in=C2=A0the
> web page http://linuxwireless.org/en/users/Drivers? Please give =C2=A0=
me the
> detailed reasons.
> =C2=A0=C2=A0=C2=A0 Very sorry to trouble you, but I really need your =
help. I'm looking
> forward to your reply and wish you good luck everyday.

No, softmac cards must support mesh in the driver. If you have a
fullmac card (non-mac80211) its up to the driver itself whether or not
mesh is supported.

There is a big column for drivers which support Mesh here:

http://wireless.kernel.org/en/users/Drivers

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
