Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53111 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab1CSQYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 12:24:08 -0400
Received: by iwn34 with SMTP id 34so5023459iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Mar 2011 09:24:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTiniNj9vcYdSBpp+28zMDJEN-=hq40_1zxcrg74J@mail.gmail.com>
References: <AANLkTiniNj9vcYdSBpp+28zMDJEN-=hq40_1zxcrg74J@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sat, 19 Mar 2011 09:23:48 -0700
Message-ID: <AANLkTimnA8LE6FgVx4sVLUxCV52_YzKm4fzAXoUHz339@mail.gmail.com>
Subject: Re: terminology questions
To: Sean Robinson <seankrobinson@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 19, 2011 at 9:18 AM, Sean Robinson <seankrobinson@gmail.com> wrote:
>  I am working on writing various components for user-space control of
> nl80211 devices.  I have had some difficulty understanding the
> terminology that is taken for granted in source files for and
> documentation about nl80211/cfg80211.  So, in the interest of learning
> the terms used I am volunteering to edit the glossary page
> <http://wireless.kernel.org/en/developers/Documentation/Glossary> on
> the Linux wireless wiki, for at least a brief time (1-2 months).  As I
> learn a new definition for an appropriate term, I will add it the the
> Glossary.
>
>  If you have encountered a word or phrase about the Linux wireless
> system for which you need(ed) a definition.  Please let me know and I
> will add it to the list of terms to define.
>
>  Can anyone answer (or point me to more resources for) the following
> questions that I can use to update the Glossary?  What is a station?
> How does a station relate to an AP?  What are the delineations between
> mac80211/cfg80211/nl80211?
>

You might want to start with the IEEE 802.11-2007 standards document
(free for download at
http://standards.ieee.org/about/get/802/802.11.html).  That has many
of the definitions you will want, e.g., station is defined as 3.136 in
their Definitions section.

Dan
