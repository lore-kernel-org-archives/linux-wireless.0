Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35813 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbcEDN2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2016 09:28:24 -0400
Received: by mail-wm0-f50.google.com with SMTP id e201so188116549wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2016 06:28:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a90ef573f6e443b6b968e263d51160c5@SC-EXCH04.marvell.com>
References: <CAAfyv37f-+suz206JR3Cdnzt57b1YEtfgVp0W+5GJ5keWNdnNQ@mail.gmail.com>
	<a90ef573f6e443b6b968e263d51160c5@SC-EXCH04.marvell.com>
Date: Wed, 4 May 2016 15:28:22 +0200
Message-ID: <CAAfyv348qRZ9VSsWmOkLov+wWuGdybrEAVjPnwZ_X4Job10OBw@mail.gmail.com> (sfid-20160504_152827_996896_5C34B0FF)
Subject: Re: mwifiex 8897 disable 11ac in sta mode
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, May 4, 2016 at 3:04 PM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Marek,
>
>> From: Belisko Marek [mailto:marek.belisko@gmail.com]
>> Sent: Wednesday, May 04, 2016 5:48 PM
>> To: linux-wireless@vger.kernel.org; Amitkumar Karwar
>> Subject: mwifiex 8897 disable 11ac in sta mode
>>
>> Hi,
>>
>> it is possible somehow to disable 11ac in mwifiex driver for sta mode(I
>> tried in wpa_supplicant by disable_vht without success). Any ideas? Many
>> thanks.
>
> There is not standard way. You can try attached hack.
Thanks. It helps.
>
> Regards,
> Amitkumar

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
