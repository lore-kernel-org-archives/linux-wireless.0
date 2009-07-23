Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:48781 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbZGWPQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 11:16:25 -0400
Received: by yxe14 with SMTP id 14so539584yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 08:16:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A687B85.3070309@lwfinger.net>
References: <22f678c60907181747h26bcd4edyae5cc16627c35bdd@mail.gmail.com>
	 <4A687B85.3070309@lwfinger.net>
Date: Thu, 23 Jul 2009 10:16:25 -0500
Message-ID: <549053140907230816g297b674agfad445057a22dd65@mail.gmail.com>
Subject: Re: howto ignore rfkill switch
From: Carl Karsten <carl@personnelware.com>
To: wireless <linux-wireless@vger.kernel.org>,
	networkmanager-list@gnome.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 10:02 AM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> Helen Gray wrote:
>> Hi,
>>
>> I have a laptop with a dodgy rfkill switch. It switches on and off
>> randomly when touch the laptop panel above it. To avoid the problem,
>> I've installed a PCMCIA card

Sounds like it would be good to just disable the switch, right?  From
what I gather, the switch signals the OS, which then runs code to
disable the wifi hardware, so overriding that is very possible.


-- 
Carl K
