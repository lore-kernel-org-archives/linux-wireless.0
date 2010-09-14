Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48692 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab0INOeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 10:34:19 -0400
Received: by iwn5 with SMTP id 5so6143126iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 07:34:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <804B13F8F3D94A4AB18B9B01ACB68FA103AB036A@EXCHSRV.fokus.fraunhofer.de>
References: <804B13F8F3D94A4AB18B9B01ACB68FA1037B5158@EXCHSRV.fokus.fraunhofer.de>
 <20100727172020.GE8293@tux> <804B13F8F3D94A4AB18B9B01ACB68FA103AB02D1@EXCHSRV.fokus.fraunhofer.de>
 <AANLkTikcnHU+JFpt7o3UG0+=Py5HKVBMmpkvZNTpQ=uy@mail.gmail.com> <804B13F8F3D94A4AB18B9B01ACB68FA103AB036A@EXCHSRV.fokus.fraunhofer.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 14 Sep 2010 07:33:58 -0700
Message-ID: <AANLkTimsxVqcS4FvGBBvsq5S=hSr5UN4mqM6V579EXrv@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH 4/5] mac80211: add WoW support
To: "Simsek, Burak" <burak.simsek@fokus.fraunhofer.de>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 2:53 AM, Simsek, Burak
<burak.simsek@fokus.fraunhofer.de> wrote:
> Hi Luis,
>
> so far we could not find any device that worked. We ordered new ones... Will let you know in case we get something working.
> Attached you can find two patch files. Since we could not get any device working yet, I am not sure whether the patch is prepared correctly. But all your previous changes (from the first patch file) should be in. And we did not get compilation errors.
>
> Apple is interesting. We might give it a try as well. I ordered 2 mini-pci cards from sparklan (http://www.sparklan.com/product.php?func=view&prod_id=63) and (http://www.oxfordtec.com/us/p127/SparkLAN-WMIA-199N-WLAN-802.11n-draft-wifi-%202.4/5Ghz-dual-band-3T/3R-Module-%28Atheros-AR9001-AR9160-XSPAN%29-Wireless-miniP%20CI-card/product_info.html ) that I hope support wow.

Can you re-spllit all the WoW patches as I did into separate patches
and post a link to a directoy where I can download each one?

  Luis
