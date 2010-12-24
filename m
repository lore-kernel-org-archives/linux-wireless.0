Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56807.mail.re3.yahoo.com ([66.196.97.81]:21081 "HELO
	web56807.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752134Ab0LXLg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Dec 2010 06:36:27 -0500
Message-ID: <28292.82403.qm@web56807.mail.re3.yahoo.com>
Date: Fri, 24 Dec 2010 03:29:43 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: carl9170 and debian squeeze
To: linux-wireless@vger.kernel.org, Der Engel <engelster@gmail.com>
In-Reply-To: <AANLkTimL=JSK6jcF4d97Nc-vLZdeRLj8o=MbpCas-H7z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is because of driver-select. To make a long story short, download and install the entire compat-wireless suit (without driver select). If the current version fails to compile download the one from the day before and so on until you find a version which compiles entirely. Then you'll have support for all of your wireless cards.


Walter


      
