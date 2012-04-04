Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab2DDQOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 12:14:16 -0400
Date: Wed, 4 Apr 2012 18:13:19 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kamil Grzebien <ciptok@gmail.com>
Cc: Kamil Grzebien <ciptok@gmail.com>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Initializing iwl3945 error
Message-ID: <20120404161317.GB14078@redhat.com> (sfid-20120404_181437_717497_840C8E51)
References: <CANHD2=rF6dBkLLkWAj8uS3nq0B1wCt7Uvu=HzO84UNz2kuiaFg@mail.gmail.com>
 <20120313081235.GC15333@redhat.com>
 <CAErSpo6t-cVBdJfyARi3ifEuBUvopbG5GQSP5YywrvumDK8HFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAErSpo6t-cVBdJfyARi3ifEuBUvopbG5GQSP5YywrvumDK8HFA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2012 at 03:08:43PM -0600, Bjorn Helgaas wrote:
> The bug report (http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2143)
> has a lot of logs, but they're pretty old and I can't tell how
> applicable they are to your situation.
> 
> It would be useful to see a complete dmesg log, /proc/iomem, and
> "lspci -vv" output from your machine after the problem occurs, and
> also the same information when it works (when using the noapic flag).

Kamil, ping, can you provide requested information?

Stanislaw
