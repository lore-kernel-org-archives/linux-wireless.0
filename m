Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:34556 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139Ab0JLKwY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 06:52:24 -0400
Subject: Re: Chromium Wifi test ?
From: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
To: ext Jim Harvey <jmhrv3@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>,
	Sam Leffler <sleffler@chromium.org>
In-Reply-To: <AANLkTimFhnAM2wo=wrDUMg6fcQ6DuyjgpvDqk9k2t4hT@mail.gmail.com>
References: <AANLkTimFhnAM2wo=wrDUMg6fcQ6DuyjgpvDqk9k2t4hT@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 13:46:50 +0300
Message-ID: <1286880410.17497.261.camel@tukatila-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, 2010-10-12 at 10:41 +0200, ext Jim Harvey wrote:
> Hello,
> 
> An Automated WiFi Testing facility was presented at the last wireless
> summit by the chromium folks:
> 
> http://wireless.kernel.org/en/developers/Summits/SanFranciscoBayArea-2010
> 
> I can see that it is built on top of autotest, but I can't seem to
> find the actual wifi tests.. can you please send a link to it ?

I'm not involved with project, but the git URL is this:
http://src.chromium.org/git/autotest.git
Wifi-tests are located in client/site_tests and server/site_tests,
as far as I found them.

And there's some kind of wiki here:
http://autotest.kernel.org/wiki/AutoTest

-Tuomas


