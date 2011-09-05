Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab1IEJYU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 05:24:20 -0400
Date: Mon, 5 Sep 2011 11:24:25 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	linux-kernel@vger.kernel.org
Subject: Re: iwl4965: "MAC is in deep sleep!" freezes
Message-ID: <20110905092423.GD2221@redhat.com> (sfid-20110905_112446_334932_A498FA41)
References: <bbdbd01d4965ae789384bc1f9d0a2426@imap.dd24.net>
 <20110902233806.GA22157@elie>
 <1315053922.6355.8.camel@fermat.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1315053922.6355.8.camel@fermat.scientia.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On Sat, Sep 03, 2011 at 02:45:22PM +0200, Christoph Anton Mitterer wrote:
> If there's any quick fix (like reverting the patch above) I'd be happy
> to test it,
No patch is available for that problem as far as I know. I requested for
verbose debug messages for now.

> ... cause I'm on a conference next week,.. and having no Wifi
> there is annyoing.
Perhaps you can downgrade kernel to 2.6.38 to make wifi works.

Stanislaw
