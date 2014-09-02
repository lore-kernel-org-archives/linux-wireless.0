Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37065 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaIBPaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 11:30:20 -0400
Date: Tue, 2 Sep 2014 11:29:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Greger <mgreger@display-solution.com>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com,
	sgruszka@redhat.com
Subject: Re: Intel 4965AGN - Android Implementation for Boundary SabreLite
 mini PCIe, Android 4.3
Message-ID: <20140902152939.GD5742@tuxdriver.com> (sfid-20140902_173024_220417_EDAC2909)
References: <F653787480BF5A439D4259B266FA81686A89D2@sbs2003.DisplaySolution.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <F653787480BF5A439D4259B266FA81686A89D2@sbs2003.DisplaySolution.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can you even still buy those cards?

Anyway, that hardware should be covered by iwlegacy (not iwlagn).
The firmware is packaged by a number of distros if you can't find
it elsewhere...

Hth!

John

On Tue, Sep 02, 2014 at 09:52:31AM +0200, Michael Greger wrote:
> Dear Sir or Madam,
> 
> my name is Michael from Gilching near Munich in Germany. We are using the sabreLite for Digital Signage purposes and want to use the Intel 4965AGN miniPCIe module on the SabreLite. The Sabre Lite is an Android board with the Freescale i.MX6q (Arm) processor. 
> My intention is to get the WIFI module running on my board. I found the article "How to enable PCIe WiFi into i.MX6 Android Release" , but this helps not much.
> -	First thing is that I need the file iwlwifi4965-2.ucode file, appropriate for my Android 4.3, kernel 3.0.35 system.
> -	Then, what module do I need in the kernel, iwlagn or iwl4965 or both?
> 
> 
> Do you have any working code for the 4965AGN under an  iMX6 system under Android 4.3?
> 
> Many thanks and best regards,
> Michael
> 
> 
> Mit freundlichen Grüßen
> Michael Greger
> ____________________________________________________
>  
> 
>  
> Michael Greger
> Dipl. Ing. (FH) 
> Entwicklung
> 
> Display Solution AG
> Talhofstr. 32
> 82205 Gilching
> Deutschland
> 
> Tel:  +49 (0) 81 05 / 7 34 03 -33
> Fax: +49 (0) 81 05 / 7 34 03 -79
> E-Mail: mgreger@display-solution.com    
> Web: www.display-solution.com 
> Handelsregister: Augsburg HRB 22144
> Vorstandsvorsitzender: Norbert Feuchtgruber
> Vorstand: Günther Hirschberger, Norbert Erhart, René Auer
> Aufsichtratsvorsitzende: Gabriele Erhart
> 
> 
> Diese Nachricht ist vertraulich und nur für den Adressaten bestimmt. 
> Sollten Sie irrtümlich diese Nachricht erhalten haben, bitte ich um Ihre 
> Mitteilung per E-Mail oder unter oben angegebener Telefonnummer
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
