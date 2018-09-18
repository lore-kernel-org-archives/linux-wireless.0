Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbeIRR2h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 13:28:37 -0400
Date: Tue, 18 Sep 2018 13:56:17 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sid Hayn <sidhayn@gmail.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org, dcaratti@redhat.com
Subject: Re: mt76x0 bug report
Message-ID: <20180918115616.GC15285@redhat.com> (sfid-20180918_135625_393772_47671C69)
References: <20180906093213.GB16539@redhat.com>
 <CAM0KTbBRGqNAu1H0myVoWg6Qu1aMXMneSJ7bXQUKbJGZUFkC_A@mail.gmail.com>
 <CAJ0CqmXHHE2J5O4irPogrypL_H95EDm2y+1_6rpWG1v3ZHxzXA@mail.gmail.com>
 <CAM0KTbAF_ztZzFk_iECyPbiWY69xrcdT_93ypnuTzocjX_fRuQ@mail.gmail.com>
 <20180907082413.GC2725@localhost.localdomain>
 <CAM0KTbAputKNN3seOfN-1zhz5XmT6yg_pbKBnapOsR6Vigv1XQ@mail.gmail.com>
 <CAM0KTbAu-LJ2ThAHbmbrggMw_ttpQ8fXr0+HTjGBZF6PBPiD8Q@mail.gmail.com>
 <CAJ0CqmUDT44W7sb4qpmt6mPDZ5LwUDPgKCrhor_8POWpx_RaQA@mail.gmail.com>
 <CAM0KTbDb4X7JZgYZa6-NmjD72_UHOqQ43Czv=HwWS3D0WcWrgQ@mail.gmail.com>
 <CAM0KTbA0QE-5oTz-aeU9zmnCS-LrYZmHwmEv0afjR0yFWvTevA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAM0KTbA0QE-5oTz-aeU9zmnCS-LrYZmHwmEv0afjR0yFWvTevA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 17, 2018 at 11:18:57PM -0400, Sid Hayn wrote:
> Sorry to bump the one thing that we both agreed was low priority but....
> 
> So was testing all of my dongles that use the driver you are working
> on, and running them through my connect scripts.  I moved the AP to
> maybe <5ft from the clients and something wierd happened.  The t1u
> tried to connect to one of the 2.4GHz only networks.  It failed, but
> it actually got enough scan data back to attempt authentication with a
> valid 2.4GHz only bssid.  Which means in short, that the eeprom isn't
> lying and your parsing of it is correct.  Something obviously makes
> this a 5GHz only device, as the connection failed and most of the time
> nothing at all is seen on 2.4GHz, but clearly it's some filter or
> antenna or some other mechanism which makes it 5GHz only.  So probably
> hardware lying to you is now even lower on your list since this safely
> rules out the driver parsing the eeprom incorrectly.

First of all would be good to check if problem is not already solved,
latest version of the driver can be found here:
https://github.com/nbd168/wireless

Second, is there vendor driver available for this particular device?
Perhaps there are some tweeks needed that are not provided by generic
driver.

Thanks
Stanislaw 
