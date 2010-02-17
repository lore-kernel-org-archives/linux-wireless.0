Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:52677 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab0BQSpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 13:45:06 -0500
Date: Wed, 17 Feb 2010 18:45:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linux-input@vger.kernel.org, marcel@holtmann.org
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
Message-ID: <20100217184502.GA23573@srcf.ucam.org>
References: <1266356185-10324-1-git-send-email-mjg@redhat.com> <20100217052247.GD7160@core.coreip.homeip.net> <20100217180342.GA22522@srcf.ucam.org> <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2010 at 07:43:56PM +0100, Christian Lamparter wrote:

> Wait wait... do you can get another KEY_?
> 
> The reason: Some new devices come with a WPS "Push Button".
> And there's no code for them yet.

What's a WPS button? There's no fundamental issue with getting new KEY_ 
codes defined, but bear in mind that anything greater than 255 won't be 
seen by X at present.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
