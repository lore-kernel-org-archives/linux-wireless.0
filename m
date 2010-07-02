Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33896 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab0GBQHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 12:07:08 -0400
Received: by pvc7 with SMTP id 7so1338103pvc.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jul 2010 09:07:07 -0700 (PDT)
Message-ID: <4C2E0EEB.7030605@lwfinger.net>
Date: Fri, 02 Jul 2010 11:08:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: Problem with firmware load on ipw2200
References: <4C29F711.1090306@lwfinger.net> <1277876773.2536.5.camel@ct>
In-Reply-To: <1277876773.2536.5.camel@ct>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2010 12:46 AM, Pavel Roskin wrote:
> On Tue, 2010-06-29 at 08:37 -0500, Larry Finger wrote:
>> I'm trying to help an ipw2200 user on the openSUSE Wireless Forum and I'm
>> stuck. The system is failing to load the firmware with error -2 (File or
>> directory not found). The difficulty is that the required files are
>> present with the correct permissions.
>>
>> What system component might be missing and/or borked to get this symptom?
> 
> Older versions of compat-wireless had a race condition in the firmware
> code that could cause that.  From the log of the compat repository:

Thanks to all that responded. The problem turned out to be a missing
package that contained the compat-wireless scripts. The device is now
running - another satisfied "customer" that just converted his wife from
Windows to Linux. We get em one box at a time.

Larry
