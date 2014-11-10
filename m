Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58930 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbaKJKUt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 05:20:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Xnm5S-0007GJ-RT
	for linux-wireless@vger.kernel.org; Mon, 10 Nov 2014 11:20:42 +0100
Received: from cantest1.felk.cvut.cz ([147.32.86.75])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2014 11:20:42 +0100
Received: from lisovy by cantest1.felk.cvut.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2014 11:20:42 +0100
To: linux-wireless@vger.kernel.org
From: Rostislav Lisovy <lisovy@gmail.com>
Subject: Re: [ath5k-devel] Rookie needs helps with ath5k basics
Date: Mon, 10 Nov 2014 10:20:31 +0000 (UTC)
Message-ID: <loom.20141110T111634-865@post.gmane.org> (sfid-20141110_112052_923769_CDFEA8EF)
References: <loom.20140215T180245-390@post.gmane.org> <CAOpc7mFVD-+CgrFm+cBVkrOSoeQZ0TRk-jNE32D0S6rtYJp9_g@mail.gmail.com> <CAJ-Vmom7Pk09o9GPdRxEzCTinB2X9bvQE_g83nJ-1m9zD9804g@mail.gmail.com> <CAK4gkpzR=pS+XzCHLpQwzCNjaQmm7JoUE_NhVGK_mhj=EXgadw@mail.gmail.com> <CAK4gkpy8uvWJW9RaHqkxTiSza0Y+79owD=2K8V-VHf6qOH_bdA@mail.gmail.com> <CAHNKnsS_tD0GJj9xLJJM-Lf0Np=L208BeY+fwj1tnRTVU_gyjA@mail.gmail.com> <loom.20141110T105051-618@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rostislav Lisovy <lisovy@...> writes:
> 
> The questions that are still unanswered (and will definitely require
> more effort to answer) are the 802.11p standard interpretation
> regarding the OCB mode / 5.9GHz usage limitation. More specific --
> Is the 5.9GHz limited for ITS (Intelligent transportation system)
> usage only. Or for any usage as long as it uses the OCB mode? If one
> of this limitation is valid, who does actually define the restriction -

I don't know why but the message got truncated. The last paragraph
should be:

The questions that are still unanswered (and will definitely require
more effort to answer) are the 802.11p standard interpretation
regarding the OCB mode / 5.9GHz usage limitation. More specific --
Is the 5.9GHz limited for ITS (Intelligent transportation system) usage
only. Or for any usage as long as it uses the OCB mode? If one of this
limitation is valid, who does actually define the restriction --
regulatory rules of particular countries?
Another question is if the OCB mode may be used outside the 5.9GHz
range? Do we need to define the OCB_ONLY flag for 5.9GHz channels in
CRDA/wireless-regdb?

Best regards;
Rostislav


