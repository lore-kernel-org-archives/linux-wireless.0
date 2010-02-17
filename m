Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f227.google.com ([209.85.217.227]:34597 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab0BQVky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 16:40:54 -0500
References: <1266356185-10324-1-git-send-email-mjg@redhat.com> <20100217052247.GD7160@core.coreip.homeip.net> <20100217180342.GA22522@srcf.ucam.org> <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com> <20100217191708.GA15554@core.coreip.homeip.net> <22ee4e771002171142q1496842ap4079026a5c0be8c6@mail.gmail.com> <20100217195435.GA15742@core.coreip.homeip.net> <22ee4e771002171218t69cc4348ia0300a645ce9763d@mail.gmail.com> <069C4DAE-598D-45F1-99B5-DA5BAF718179@gmail.com> <22ee4e771002171328w3c9cbb8n663c291e9d3634e5@mail.gmail.com>
Message-Id: <2C0E2BCD-7589-45DE-B7D4-DBEFBFAE879D@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
In-Reply-To: <22ee4e771002171328w3c9cbb8n663c291e9d3634e5@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
Date: Wed, 17 Feb 2010 13:40:35 -0800
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"marcel@holtmann.org" <marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 17, 2010, at 1:28 PM, Christian Lamparter <chunkeey@googlemail.com 
 > wrote:

> On Wed, Feb 17, 2010 at 9:52 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>>
>> Sorry, I was not clear enough. I meant something in works in Linux  
>> software
>> stack, I was aware that certain router have these buttons already.
>>
>
> wpa_supplicant and hostapd's CLI have this wps_pbc command.
> It's more a question of: what application will get to receive the  
> event.

Right. So as soon as you have an idea about userspace consumer for the  
event ping me and I'd be glad to add a key definition for the event.

-- 
Dmitry
