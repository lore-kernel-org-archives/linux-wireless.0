Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64772 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965145Ab3BMWui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 17:50:38 -0500
Received: by mail-we0-f174.google.com with SMTP id r6so1444428wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2013 14:50:36 -0800 (PST)
Message-ID: <511C1745.4000502@gmail.com> (sfid-20130213_235052_333835_9DB192B5)
Date: Wed, 13 Feb 2013 23:44:21 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	wireless-regdb@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [wireless-regdb] wireless-regdb: Update regulatory rules for
 Serbia (RS) on 2.4 and 5GHz
References: <CAL1G+-HfPJnwvisiE5Vr0ihenwKzL3_QL40DLPP_PsPyv+nveQ@mail.gmail.com> <20130206192544.GH2148@tuxdriver.com>
In-Reply-To: <20130206192544.GH2148@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2013 08:25 PM, John W. Linville wrote:

> Thank you so much for this timely message!  I apologize for having
> overlooked it so far.
> 
> I don't suppose that you could translate the information you have
> provided into the format used within the regulatory database file?
> Also, could you provide a link to the original regulatory document
> (even if it is in Serbian)?

Serbia is under ETSI/CEPT rules( ECC/DEC/(04)08 ), see summary[1]:

5 GHz current rules are too much liberal and incomplete:

country RS:
	(2400 - 2483.5 @ 40), (N/A, 100 mW)
	(5150 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR
	(5470 - 5725 @ 20), (3, 1000 mW), DFS
	# 60 gHz band channels 1-4, ref: Etsi En 302 567
	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR

They should be changed to "standard" ETSI rules:
	(2400 - 2483.5 @ 40), (N/A, 100 mW)
	(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
	# 60 gHz band channels 1-4, ref: Etsi En 302 567
	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR

http://www.erodocdb.dk/doks/implement_doc_adm.aspx?docid=2033
http://www.erodocdb.dk/doks/implement_adm_doc.aspx?ITUID=48&ITUSHORT=RS&ITULONG=Serbia

Contact point for implementation status:
Ms Jelena Surculija <jelena.surculija@mtid.gov.rs>
Dr Milan Jankovic <milan.jankovic@ratel.org.rs>


[1] http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000058.html
