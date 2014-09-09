Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:63974 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaIIVxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 17:53:30 -0400
Received: by mail-oa0-f51.google.com with SMTP id n16so12410489oag.38
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2014 14:53:29 -0700 (PDT)
Message-ID: <540F76D8.8090807@lwfinger.net> (sfid-20140909_235333_415187_6BB87043)
Date: Tue, 09 Sep 2014 16:53:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Realtek GPIO chipset, for Baytrail?
References: <1410256608.4077.7.camel@hadess.net> <540F54B1.8040409@lwfinger.net> <1410292835.4077.21.camel@hadess.net> <540F61FE.2050404@lwfinger.net> <7234781D-5B78-404A-B945-D090938777C7@hadess.net>
In-Reply-To: <7234781D-5B78-404A-B945-D090938777C7@hadess.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/2014 04:22 PM, Bastien Nocera wrote:
>
> I'm not sure why the device doesn't show up in the sysfs tree, but maybe it needs a driver bound to it to show up.

The driver creates those entries when it loads. It is no mystery why they are 
missing.

Larry


