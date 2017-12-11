Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:55767 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdLKMhI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 07:37:08 -0500
Subject: Re: [PATCH v2 3/5] mac80211_hwsim: add generation count for netlink
 dump operation
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
 <7ee141a4-8983-4da6-9c0f-f070fa6e5611@MAIL2.uni-rostock.de>
 <1512994493.26976.74.camel@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <8264ae6e-7db6-53b0-88c0-4ac4e51d0ba3@uni-rostock.de> (sfid-20171211_133713_085419_897BF9A8)
Date: Mon, 11 Dec 2017 13:37:28 +0100
MIME-Version: 1.0
In-Reply-To: <1512994493.26976.74.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 11.12.2017 um 13:14 schrieb Johannes Berg:
> On Tue, 2017-11-21 at 13:17 +0100, Benjamin Beichler wrote:
>> Make the dump operation aware of changes on radio list and corresponding
>> inconsistent dumps. Change the dump iteration to be independent from
>> increasing radio indices on radio list.
> Looks like this should use nl=5Fdump=5Fcheck=5Fconsistent()=3F
>
> johannes
>
It is called in mac80211=5Fhwsim=5Fget=5Fradio, I didn't changed that.

-- 
M.Sc. Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrotechnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/
