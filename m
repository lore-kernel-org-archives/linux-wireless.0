Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64698 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab1LNUGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 15:06:53 -0500
Received: by ggdk6 with SMTP id k6so1083857ggd.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 12:06:52 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 14 Dec 2011 15:06:52 -0500
Message-ID: <CA+7oygebaTjmGRhXBDQFJb39pLGZiDFUfNLJF9n6b_K4FgQEvA@mail.gmail.com> (sfid-20111214_210656_583337_CDA7C34A)
Subject: current state of default CCA mode?
From: George Nychis <gnychis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was wondering what the current state of the default CCA mode is in
compat-wireless and if it's consistent across the various drivers
(i.e., ath9k, b43, wl12xx, etc)?  Is the default mode shifting from
mode 1 to mode 2?

Also, if anyone has any intuition of what is happening outside of
compat-wireless in terms of the CCA mode, I would really appreciate
it.

Thanks!

- George
