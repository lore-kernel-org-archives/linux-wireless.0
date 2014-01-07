Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41025 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaAGSOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 13:14:25 -0500
Received: by mail-wg0-f52.google.com with SMTP id b13so238345wgh.7
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jan 2014 10:14:24 -0800 (PST)
Date: Tue, 7 Jan 2014 19:13:33 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 12/13] iwlwifi: mvm: rs: overhaul search cycle state
 machine
Message-ID: <20140107181333.GB7267@magnum.frso.rivierawaves.com> (sfid-20140107_191431_799109_ACAED010)
References: <529CF2D6.1080008@gmail.com>
 <1386017965-13641-12-git-send-email-egrumbach@gmail.com>
 <20140106150716.GA5358@magnum.frso.rivierawaves.com>
 <CAF8O4-y4K_0G=3e2fcNzfJuGSz6WwrUU3EyL1H3B7Z6-koGFyw@mail.gmail.com>
 <20140107102746.GA20561@magnum.frso.rivierawaves.com>
 <CAF8O4-xaNWO+tFS=0+ffR5aKf0Z+OWDBSPpnjYWUgP86Oiey2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
In-Reply-To: <CAF8O4-xaNWO+tFS=0+ffR5aKf0Z+OWDBSPpnjYWUgP86Oiey2g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Jan 07, 2014 at 06:30:07PM +0200, Eyal Shapira wrote:
> Thanks. Seems like we decided the AP doesn't support any MIMO rates.
> This wasn't handled well and caused the search cycle for an optimal Tx
> configuration to get stuck.
> Can you try the attached patch ?
> 
Working, thanks.

> Also, any chance you can send a traffic capture of some beacons and the assoc ?
> I'd like to understand why we come to the conclusion no MIMO is supported.
> 
AP limitation, but here is a capture anyway.
 
Karl

--ikeVEW9yuYc//A+q
Content-Type: application/vnd.tcpdump.pcap
Content-Disposition: attachment; filename="iwlwifi-11n-5180_40MHz.pcap"
Content-Transfer-Encoding: base64

1MOyoQIABAAAAAAAAAAAAP//AAB/AAAA2UDMUm5aCwCrAAAAqwAAAAAAHgAuQACgIAgAoCAI
AAAADDwUQAHNAAAAygDNAVAAPAAAFQC5xuM6u8zd7v86u8zd7v/QC6ViygIAAAAAyAABAAAC
QVABCIwSmCSwSGBsAwEkLRpuARv/AAAAAAAAAAAAlgABAAAAAAAAAAAAAD0WJAUAAAAAAAAA
AAAAAAAAAAAAAAAAAH8IAAAAAAAAAEDdGABQ8gIBAQAAA6QAACekAABCQ10AYjIuANlAzFIJ
zAsAKwAAACsAAAAAAA0ABIACAAwAAAAAsAA8ADq7zN3u/wAVALnG4zq7zN3u/wAAAAABAAAA
2UDMUmzOCwA8AAAAPAAAAAAAHgAuQACgIAgAoCAIAAAADDwUQAHOAAAAywDOAbAAPAAAFQC5
xuM6u8zd7v86u8zd7v/gCwAAAgAAANlAzFKW2wsAXAAAAFwAAAAAAA0ABIACAAwAAAAAAAA8
ADq7zN3u/wAVALnG4zq7zN3u/xAAAQBGAAACQVABCAwSGCQwSGBsLRrmERf//wAAAQAAAAAA
LAEBAAAAAAAAAAAAAN0HAFDyAgABANlAzFIm4wsAngAAAJ4AAAAAAB4ALkAAoCAIAKAgCAAA
AAw8FEABzgAAAMsAzgEQADwAABUAucbjOrvM3e7/OrvM3e7/8AsBAAAAAcABCIwSmCSwSGBs
LRpuARv/AAAAAAAAAAAAlgABAAAAAAAAAAAAAD0WJAUEAAAAAAAAAAAAAAAAAAAAAAAAAH8I
AAAAAAAAAEDdGABQ8gIBAQAAA6QAACekAABCQ10AYjIuANlAzFK9Ag8AsQAAALEAAAAAAB4A
LkAAoCAIAKAgCAAAAAw8FEABzgAAAMsAzgGAAAAA////////OrvM3e7/OrvM3e7/EAwFoMsC
AAAAAMgAAQAAAkFQAQiMEpgksEhgbAMBJAUEAQIAAC0abgEb/wAAAAAAAAAAAJYAAQAAAAAA
AAAAAAA9FiQFBAAAAAAAAAAAAAAAAAAAAAAAAAB/CAAAAAAAAABA3RgAUPICAQEAAAOkAAAn
pAAAQkNdAGIyLgA=

--ikeVEW9yuYc//A+q--
