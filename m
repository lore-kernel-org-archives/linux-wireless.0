Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab0BQSuB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 13:50:01 -0500
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
From: Bastien Nocera <hadess@hadess.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linux-input@vger.kernel.org, marcel@holtmann.org
In-Reply-To: <20100217184502.GA23573@srcf.ucam.org>
References: <1266356185-10324-1-git-send-email-mjg@redhat.com>
	 <20100217052247.GD7160@core.coreip.homeip.net>
	 <20100217180342.GA22522@srcf.ucam.org>
	 <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com>
	 <20100217184502.GA23573@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 17 Feb 2010 18:49:35 +0000
Message-ID: <1266432575.678.980.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-02-17 at 18:45 +0000, Matthew Garrett wrote:
> On Wed, Feb 17, 2010 at 07:43:56PM +0100, Christian Lamparter wrote:
> 
> > Wait wait... do you can get another KEY_?
> > 
> > The reason: Some new devices come with a WPS "Push Button".
> > And there's no code for them yet.
> 
> What's a WPS button? There's no fundamental issue with getting new KEY_ 
> codes defined, but bear in mind that anything greater than 255 won't be 
> seen by X at present.

Won't be seen by most X applications. The server should definitely see
it, so should applications that use XInput2-aware widget sets.

(Which obviously means not much at all right now).


