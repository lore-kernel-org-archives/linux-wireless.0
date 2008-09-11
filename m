Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:50457 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbYIKTu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 15:50:27 -0400
Message-ID: <48C97682.6010109@lwfinger.net> (sfid-20080911_215033_090541_EB52660B)
Date: Thu, 11 Sep 2008 14:50:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: wireless <linux-wireless@vger.kernel.org>, furlot@free.fr
Subject: Re: Compaq laptop RFKILL problems
References: <48C80241.4000409@lwfinger.net> <20080911120002.GA1387@srcf.ucam.org>
In-Reply-To: <20080911120002.GA1387@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew Garrett wrote:
> On Wed, Sep 10, 2008 at 12:22:09PM -0500, Larry Finger wrote:
>> I'm trying to help a Ubuntu user get his BCM4303 working on a Compaq 
>> Presario R3215. His radio is hardware disabled, but the RFKILL switch 
>> does not issue a scancode when pushed. Obviously, the Windows software 
>> polls that key in some manner, but we have no idea what it does.
> 
> Can you try the hp-wmi driver?

Trying to build hp-wmi for his 2.6.24.3 kernel wouldn't be worth the 
effort; however, Ubuntu has a kernel based on 2.6.27-rc6 that was 
accepted yesterday. It will be tried ASAP.

Thanks,

Larry

