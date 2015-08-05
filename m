Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46595 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbbHEJMk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 05:12:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ZMukY-0006DH-QZ
	for linux-wireless@vger.kernel.org; Wed, 05 Aug 2015 11:12:38 +0200
Received: from gas45-3-82-244-252-119.fbx.proxad.net ([82.244.252.119])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2015 11:12:38 +0200
Received: from j.cubizolles by gas45-3-82-244-252-119.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2015 11:12:38 +0200
To: linux-wireless@vger.kernel.org
From: Julien Cubizolles <j.cubizolles@free.fr>
Subject: Re: firmware in a bad state (module mwifiex)
Date: Wed, 05 Aug 2015 11:12:25 +0200
Message-ID: <87oaim85fq.fsf@free.fr> (sfid-20150805_111253_146464_D87758A3)
References: <871tfzast5.fsf@free.fr>
	<0e2dc4e2bd9f4486979cedb4c47e60f2@SC-EXCH04.marvell.com>
	<87zj26z1pd.fsf_-_@free.fr>
	<d74ef56802d24c8e90e1b82eb5003172@SC-EXCH04.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com>
writes:


> This looks like a command timeout problem probably caused due to a bug in firmware.
> How frequently do you see this problem? Are there any specific steps to recreate it?

Surprisingly, it's reproducible:

loading https://github.com/simonwjackson/mcomix/ and clicking on issues
is enough :-)

Should I build the latest driver version from some git repo to further
investigate this problem ?

Regards,

Julien.

