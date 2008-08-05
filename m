Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4126 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758406AbYHENcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 09:32:17 -0400
Date: Tue, 5 Aug 2008 09:14:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Keir <keirlawson@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Mesh network project, feedback wanted
Message-ID: <20080805131452.GB4276@tuxdriver.com> (sfid-20080805_153221_380516_746668ED)
References: <e27b78a40808050438t7b5508e1oe034842427491520@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e27b78a40808050438t7b5508e1oe034842427491520@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 05, 2008 at 12:38:40PM +0100, Keir wrote:

> With this in mind, me and my supervisor came up with the project
> proposal that I have attached, however neither of us are hugely
> familiar with Linux mesh development.  I was wondering, does this seem
> like a sensible project proposal? Is there something better I could be
> doing given my resources?

It isn't clear to me from reading your proposal whether or not you
are aware of this:

	http://www.open80211s.org/

Were you planning to implement mesh networking code?  Or some sort
of network management code that would configure/enable/disable
mesh vs. STA vs. IBSS modes?  Or simply something that did manual
configurations and then did testing/measurements?

Obviously the 1st option is the least useful in general.
The 2nd option might be interesting especially in cooperation
with NetworkManager or a similar project.  The third option is
the most academic.  Alas, it might also make for the most boring
paper/presentation... :-)

Hth...good luck!

John
-- 
John W. Linville
linville@tuxdriver.com
