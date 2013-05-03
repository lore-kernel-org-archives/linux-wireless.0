Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:49776 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762653Ab3ECOHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 10:07:17 -0400
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "devel@lists.open80211s.org" <devel@lists.open80211s.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wirelss <linux-wireless@vger.kernel.org>
Subject: RE: [RFC 00/12] MBSS sharing across multiple interfaces
Date: Fri, 3 May 2013 14:07:14 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C5C142@RockMX01.rock.corp> (sfid-20130503_160721_859138_5DE8B33B)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
 <BD54DDEB2546894FAB0731EA7B0EDF8D07C5C070@RockMX01.rock.corp>
 <CAEFj987wqVTmN1eCCfqm2M16p5j8JtOn5AcKE0fETmsn+FyENg@mail.gmail.com>
In-Reply-To: <CAEFj987wqVTmN1eCCfqm2M16p5j8JtOn5AcKE0fETmsn+FyENg@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Question 2

In MPP where there are multiple mesh interfaces, AP interface and/or Ethernet interface, how does this "MBSS sharing" work?
        a. add both mesh interface in 802.1d bridge, or
        b. add either interface in bridge, or
        c. sharing can't be used

> As far as I know, sharing can't be used for mesh interfaces with AP or Ethernet interfaces. Perhaps, Thomas and Bob can comment further.

I am not talking about sharing with AP or Ethernet interface.
I am saying, how to bridge with AP or Ethernet?
        a. add both mesh interface in 802.1d bridge, or
        b. add either mesh interface in bridge, or
        c. if sharing is enabled, interface can't added to bridge.
