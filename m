Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:56029 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZDMVIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 17:08:43 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2360929yxl.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 14:08:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890904131400v5c484f05s13d50ada2538e555@mail.gmail.com>
References: <200904132244.24122.chunkeey@web.de> <20090413204430.GH31922@baikonur.stro.at>
	<43e72e890904131400v5c484f05s13d50ada2538e555@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 13 Apr 2009 14:08:26 -0700
Message-ID: <43e72e890904131408x30617bf6w66c2db892d654392@mail.gmail.com> (sfid-20090413_230846_641348_CAD3CF14)
Subject: Re: [PATCH] ath: add module information
To: maximilian attems <max@stro.at>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2009 at 2:00 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, Apr 13, 2009 at 1:44 PM, maximilian attems <max@stro.at> wrot=
e:
>> On Mon, Apr 13, 2009 at 10:44:23PM +0200, Christian Lamparter wrote:
>>> diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wirele=
ss/ath/Makefile
>>> index a005b91..4bb0132 100644
>>> --- a/drivers/net/wireless/ath/Makefile
>>> +++ b/drivers/net/wireless/ath/Makefile
>>> @@ -3,5 +3,4 @@ obj-$(CONFIG_ATH9K) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 +=3D ath9k/
>>> =C2=A0obj-$(CONFIG_AR9170_USB) =C2=A0 =C2=A0 =C2=A0 =C2=A0+=3D ar91=
70/
>>>
>>> =C2=A0obj-$(CONFIG_ATH_COMMON) =C2=A0 =C2=A0 +=3D ath.o
>>> -ath-objs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 :=3D regd.o
>>> -
>>> +ath-objs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 :=3D main.o reg=
d.o
>>
>> why do you put that in a different file and not in ath.c?
>
> Apart from this objection, looks good -- and thanks.

Actually a new file makes sense -- we might later add more stuff other
than regulatory. That is the idea.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
