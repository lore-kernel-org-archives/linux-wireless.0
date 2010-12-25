Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58710 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab0LYIF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Dec 2010 03:05:28 -0500
Received: by iyi12 with SMTP id 12so6259758iyi.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Dec 2010 00:05:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <FF69470D-9C14-4324-BA8E-F134B2AD9DEE@mac.com>
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com> <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com>
 <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com> <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com>
 <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com> <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
 <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com> <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com>
 <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com> <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com>
 <4D122B8F.5090302@hauke-m.de> <1813D0B1-5391-48DB-9882-A6586DAB180C@mac.com>
 <AANLkTimMWH63yG2tdu7OHemHs=6OOy_i5fpeEDhhh6O9@mail.gmail.com>
 <4D123FBB.1050801@hauke-m.de> <C7700580-CCBB-498D-9EA5-73E2BF748C68@mac.com>
 <A7C7741B-634A-4C4B-A6F1-EBEA5F2EEED5@mac.com> <4D125B9F.7090503@hauke-m.de>
 <A8ED3E8F-FA2A-46B9-95C6-F2C175581539@mac.com> <4D1266FA.7080305@hauke-m.de>
 <9AD18479-91B8-42DB-8D81-2AF11DD05405@mac.com> <AANLkTinyjZ0x1jvKndotDm-xHf0c192NQfB9y9_BQxFg@mail.gmail.com>
 <FF69470D-9C14-4324-BA8E-F134B2AD9DEE@mac.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 25 Dec 2010 10:05:07 +0200
Message-ID: <AANLkTikFoFe5HLWtY3t178BAbPFMO2E284A+1+dtcuSG@mail.gmail.com>
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 23, 2010 at 11:12 PM, Elvis Dowson <elvis.dowson@mac.com> wrote:
> Is the SDIO subsystem sufficiently modular so as to allow me to take a few file and use it as a drop in
> replacement for the 2.6.32 kernel?

I'm not sure I'm following the question...

btw, IMHO you don't need to replace any file at all. 2.6.32 has a
functional SDIO subsystem.


>
> Elvis Dowson
>
>
