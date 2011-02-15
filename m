Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16764 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab1BOSUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 13:20:15 -0500
From: "Ferraton, Jean RegisX" <jean.regisx.ferraton@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Walter Goldens <goldenstranger@yahoo.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"marcel@holtmann.org" <marcel@holtmann.org>
Date: Tue, 15 Feb 2011 18:20:11 +0000
Subject: RE: Advise on how to integrate latest bluetooth updates on linux
 2.6.35 kernel
Message-ID: <6E42A1B4DD2F7B4D80A1F26BB498BF9F8C9F71994D@irsmsx501.ger.corp.intel.com>
References: <6E42A1B4DD2F7B4D80A1F26BB498BF9F8C9F56AFD4@irsmsx501.ger.corp.intel.com>
 <456817.14949.qm@web161612.mail.bf1.yahoo.com>
 <20110210222424.GA24388@khazad-dum.debian.net>
In-Reply-To: <20110210222424.GA24388@khazad-dum.debian.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Henrique de Moraes Holschuh [mailto:hmh@hmh.eng.br]
> Sent: Thursday, February 10, 2011 11:24 PM
> To: Walter Goldens
> Cc: linux-wireless@vger.kernel.org; Ferraton, Jean RegisX;
> marcel@holtmann.org
> Subject: Re: Advise on how to integrate latest bluetooth updates on
> linux 2.6.35 kernel
> 
> On Thu, 10 Feb 2011, Walter Goldens wrote:
> > > I'm working in the bluetooth part in a project based on the
> > > 2.6.35 linux kernel.
> > >
> > > We've found some bugs related to bluetooth, and I've seen
> > > that most of these bugs have been solved by latest releases
> > > (2.6.36 and 2.6.37).
> 
> ...
> 
> > Compat-wireless is your best bet. Noninvasive solution to your
> problem.
> 
> There is a 2.6.35 longterm, as well as stable 2.6.36.  If these are
> real
> fixes that address bugs users will find on the field, they might well
> be
> candidates for the stable (and longterm) releases.  And THAT is always
> much
> preferable over compat-wireless, as it would be helpful to a lot more
> users.
> 
> --

Hi,

I've tried to use the compat-wireless solution, but it is impossible, as in our case we are using a BT driver bt_drv which is in the kernel and depends on bluetooth.h and is incompatible with the compat version. So it is impossible to use the compat solution.

Now I'm trying to use the bluetooth-next tree, replacing the Bluetooth stuff in my kernel. Technically, it works fine.

Do you think this kind of implementation is acceptable?
If not, what would you recommend?

Regards

Jean
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

