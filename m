Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33234 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbcAOOxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 09:53:03 -0500
Received: by mail-lb0-f170.google.com with SMTP id x4so59631527lbm.0
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jan 2016 06:53:01 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 15 Jan 2016 14:53:01 +0000
Message-ID: <CAMMzQ-gw2HduF31BWXHyOst3Ms7NcbduUL04P=wiAX7if35LqQ@mail.gmail.com> (sfid-20160115_155307_155974_936CCC0B)
Subject: Purpose of CRDA and feature sets utilised by third parties
From: "mattmill30 ." <mattmill30@googlemail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been inspecting CRDA to rationalise it's dependency upon python,
as well as the dependant relationship of wpa_supplicant.

The CRDA documentation
(https://wireless.wiki.kernel.org/en/developers/Regulatory/CRDA)
doesn't provide a rationale for the software (beyond "regulatory
compliance") or specify it's feature set; which I'm hoping to realise.

My understanding is that CRDA is a software/library to query the
wireless-regdb, with a config file to specify the device location.

However, the key2pub.py utility and dependency upon m2crypto suggests
CRDA also handles encryption, which seems outside of the frequency
band selection function.
Please would someone clarify the features of CRDA?
Also, is it possible to --disable- unwanted CRDA features through
configure; or otherwise excluse python and m2crypto dependent
features?

Also, what changes between wpa_supplicant being compiled and used
with/without CRDA?

Many thanks
