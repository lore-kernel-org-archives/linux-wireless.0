Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web161612.mail.bf1.yahoo.com ([98.139.211.134]:38468 "HELO
	web161612.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752728Ab1BJMvq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 07:51:46 -0500
Message-ID: <456817.14949.qm@web161612.mail.bf1.yahoo.com>
Date: Thu, 10 Feb 2011 04:45:06 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Advise on how to integrate latest bluetooth updates on linux 2.6.35 kernel
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jean RegisXFerraton <jean.regisx.ferraton@intel.com>
Cc: "marcel@holtmann.org" <marcel@holtmann.org>
In-Reply-To: <6E42A1B4DD2F7B4D80A1F26BB498BF9F8C9F56AFD4@irsmsx501.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm working in the bluetooth part in a project based on the
> 2.6.35 linux kernel.
> 
> We've found some bugs related to bluetooth, and I've seen
> that most of these bugs have been solved by latest releases
> (2.6.36 and 2.6.37).
> 
> To implement these modifications, I have the following
> options:
> 
> 1- Implement all the patches one by one
> 2- Use the bluetooth modules (*.ko) included in the latest
> compat-wireless release
> 3- Overwrite the bluetooth source files in the kernel with
> the ones coming from compat-wireless  and rebuild
> 
> In my opinion, the 2nd solution seems the cleaner and
> easier way to achieve this. Could you advise me about the
> best way to proceed?
> Thanks
> 
> Regards

Compat-wireless is your best bet. Noninvasive solution to your problem.

Walter


      
