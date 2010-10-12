Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:21221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396Ab0JLN4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 09:56:35 -0400
Received: from kpbe20.cbf.corp.google.com (kpbe20.cbf.corp.google.com [172.25.105.84])
	by smtp-out.google.com with ESMTP id o9CDuXbQ027672
	for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 06:56:34 -0700
Received: from gwj16 (gwj16.prod.google.com [10.200.10.16])
	by kpbe20.cbf.corp.google.com with ESMTP id o9CDuKkO024427
	for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 06:56:32 -0700
Received: by gwj16 with SMTP id 16so1562705gwj.21
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 06:56:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286880410.17497.261.camel@tukatila-desktop>
References: <AANLkTimFhnAM2wo=wrDUMg6fcQ6DuyjgpvDqk9k2t4hT@mail.gmail.com>
	<1286880410.17497.261.camel@tukatila-desktop>
Date: Tue, 12 Oct 2010 06:56:31 -0700
Message-ID: <AANLkTimLigZq6CaotcDKxcVOzKn_hVw98RTvub+r0M8-@mail.gmail.com>
Subject: Re: Chromium Wifi test ?
From: Paul Stewart <pstew@google.com>
To: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
Cc: ext Jim Harvey <jmhrv3@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sam Leffler <sleffler@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 12, 2010 at 3:46 AM, Tuomas Katila
<ext-tuomas.2.katila@nokia.com> wrote:
> Hi,
>
> On Tue, 2010-10-12 at 10:41 +0200, ext Jim Harvey wrote:
>> Hello,
>>
>> An Automated WiFi Testing facility was presented at the last wireless
>> summit by the chromium folks:
>>
>> http://wireless.kernel.org/en/developers/Summits/SanFranciscoBayArea-2010
>>
>> I can see that it is built on top of autotest, but I can't seem to
>> find the actual wifi tests.. can you please send a link to it ?
>
> I'm not involved with project, but the git URL is this:
> http://src.chromium.org/git/autotest.git
> Wifi-tests are located in client/site_tests and server/site_tests,
> as far as I found them.
>
> And there's some kind of wiki here:
> http://autotest.kernel.org/wiki/AutoTest
>
> -Tuomas

Tuomas has it right.  The suite directories that start with
network_WiFi* are the 802.11 related test suites.

--
Paul
