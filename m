Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:54500 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3BMWxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 17:53:49 -0500
From: "Green, Michael" <green@qca.qualcomm.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Russia Update (not Serbia)
Date: Wed, 13 Feb 2013 22:53:47 +0000
Message-ID: <237CF5B631AA3446BAC55A2F73815CEB0154C3A8@NASANEXD02D.na.qualcomm.com> (sfid-20130213_235356_889431_374B76E6)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry.  We have reached the limit of my cooperation.  I trust the community to do the right thing from this point.   


Michael Green
green@qualcomm.com

Qualcomm Atheros, Inc.
781-400-1491 (office)
508-380-4921 (cell)


-----Original Message-----
From: wireless-regdb-bounces@lists.infradead.org [mailto:wireless-regdb-bounces@lists.infradead.org] On Behalf Of Xose Vazquez Perez
Sent: Wednesday, February 13, 2013 5:44 PM
To: linux-wireless; wireless-regdb@lists.infradead.org; John W. Linville
Subject: Re: [wireless-regdb] wireless-regdb: Update regulatory rules for Serbia (RS) on 2.4 and 5GHz

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
Ms Jelena Surculija <jelena.surculija@mtid.gov.rs> Dr Milan Jankovic <milan.jankovic@ratel.org.rs>


[1] http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000058.html

_______________________________________________
wireless-regdb mailing list
wireless-regdb@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/wireless-regdb
