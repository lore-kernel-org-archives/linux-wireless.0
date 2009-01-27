Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rebar.astron.com ([38.117.134.202]:51074 "EHLO rebar.astron.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbZA0Rtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 12:49:39 -0500
From: christos@zoulas.com (Christos Zoulas)
Date: Tue, 27 Jan 2009 12:28:48 -0500
In-Reply-To: <20090127165416.GJ19242@tesla>
       from "Luis R. Rodriguez" (Jan 27,  8:54am)
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] file-4.26: add wireless-regdb magic file format
Cc: <file@mx.gw.com>, <linux-wireless@vger.kernel.org>
Message-Id: <20090127172848.5A6A55654E@rebar.astron.com> (sfid-20090127_184943_657361_95450455)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 27,  8:54am, lrodriguez@atheros.com ("Luis R. Rodriguez") wrote:
-- Subject: [PATCH] file-4.26: add wireless-regdb magic file format

| Christos, this patch adds the wireless-regdb magic file format
| to the file Magdir. We use this binary file format in Linux for our
| wireless regulatory database parsed by CRDA. If there are any questions
| please feel free to puke us on the linux-wireless list.
| 
| Do you have plans on releasing a file-4.27 any time soon?
| 
| Thanks to Johannes for coming up with this.
| 
|   Luis
| 
| --- /dev/null	2009-01-18 12:51:54.000000000 -0800
| +++ file-4.26/magic/Magdir/wireless-regdb	2009-01-27 08:40:43.000000000 -0800
| @@ -0,0 +1,6 @@
| +# wireless-regdb:        file(1) magic for CRDA wireless-regdb file format
| +#
| +# CRDA Regulatory database file
| +# http://wireless.kernel.org/en/developers/Regulatory
| +0       belong          0x52474442
| +>4      belong          19              (Version 1)

Isn't that belong really:

0	string	RGDB    CRDA wireless regulatory database file
>4	belong	19	(Version 1)

???

christos
