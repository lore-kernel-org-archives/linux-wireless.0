Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755161AbdLOMVd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Dec 2017 07:21:33 -0500
Date: Fri, 15 Dec 2017 13:20:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: BCM4356 does not initalize after firmware update
Message-ID: <20171215122045.GB2742@redhat.com> (sfid-20171215_132158_571555_5771192F)
References: <20171213161257.GB2811@redhat.com>
 <5A3240B9.90007@broadcom.com>
 <20171214142243.GB2737@redhat.com>
 <5A339CB2.1040202@broadcom.com>
 <20171215103215.GA2742@redhat.com>
 <5A33ADAA.9060008@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A33ADAA.9060008@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 15, 2017 at 12:10:34PM +0100, Arend van Spriel wrote:
> # cat /sys/kernel/debug/brcmfmac/0000:03:00.0/revinfo

vendorid: 0x14e4
deviceid: 0x43ec
radiorev: 0.41.32.105
chipnum: 17238 (4356)
chiprev: 2
chippkg: 2
corerev: 48
boardid: 0x0777
boardvendor: 0x14e4
boardrev: P103
driverrev: 7.35.180.119
ucoderev: 0
bus: 0
phytype: 11
phyrev: 17
anarev: 0
nvramrev: 00000000

Regards
Stanislaw
