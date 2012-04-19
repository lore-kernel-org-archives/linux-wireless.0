Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38012 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2DSNZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 09:25:34 -0400
Message-ID: <4F901224.1040508@sipsolutions.net> (sfid-20120419_152538_234058_25F41FAD)
Date: Thu, 19 Apr 2012 06:24:52 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Dominik Feser <dominik.feser@googlemail.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: wlan0 not present
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com> <4B048FDE-C784-4401-9FEC-16F8CC0B8D59@gmail.com> <CANUX_P0FO-P6ZFow15shNpZg6Z8FAPP7AovJH=xUKPyVEMtoBw@mail.gmail.com> <FC927BD3-30FD-4DF2-A65C-5BE785FB72BC@gmail.com> <CANUX_P0dR93vJicsrnpxPmOZvaxBvaONHQiFXOTcaP1Ax0LAnQ@mail.gmail.com> <816C5F70-E340-46F9-8206-2B230A27F3AD@gmail.com> <CANUX_P3=ttVKdLYBfAdGRhmfDRbPruogw8Eo_d09on0ajdTqUw@mail.gmail.com> <5714877C-2465-4FD5-94A0-9D0806A803C4@gmail.com> <CANUX_P27GoLY2q9jmsWw9Rzn9posf3mCjDa98+q4JP=83wYthg@mail.gmail.com> <8FBCAE90-FAE9-430D-888E-F055091E6683@gmail.com> <CANUX_P1OxH7rmYWxizEaf2DnPSTK0npNtZ2Q9Rm5dksnmFKD8g@mail.gmail.com> <9D52D4AD-58DC-4896-97FC-7248E1FD2614@gmail.com> <CANUX_P1ZX_e+0qs4sa7vdAqHvOQjO6+9PiFhDbW8ybE4ax80gQ@mail.gmail.com> <8EE08C44-8618-45EC-B890-B5B12B661FB6@gmail.com> <CANUX_P0O0-6sOaN59V_RxLj_DbiTdNdwq0zze6B6vMe1hfQuqA@mail.gmail.com> <37926591-261D-4C3E-A1D9-4A8AB3364F5D@gmail.com> (sfid-20120419_152129_778732_024C8F79)
In-Reply-To: <37926591-261D-4C3E-A1D9-4A8AB3364F5D@gmail.com> (sfid-20120419_152129_778732_024C8F79)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/19/2012 6:20 AM, Dominik Feser wrote:
> Ah ok, this is what I did several times now. After unpacking there is no .config file. After running the driver-select script and making the driver the first time the .config file appears.
> Just then it seems to me that f I add the debug line to .config and remake this isn't recognized by the make...

You should modify config.mk, not .config

johannes
